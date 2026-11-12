import SwiftUI
import MapKit
import SunMapEngine

struct WalkPlace: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var subtitle = ""
}

struct WalkPreview: Identifiable {
    let route: WalkRoute
    let coordinates: [CLLocationCoordinate2D]
    var id: WalkKind { route.kind }
}

extension WalkKind {
    var color: UIColor {
        switch self {
        case .fastest: return .systemBlue
        case .balanced: return .systemPurple
        case .sunniest: return .systemOrange
        }
    }
}

actor WalkService {
    func routes(from start: WalkPlace, to end: WalkPlace, date: Date) async throws -> [WalkPreview] {
        let city = try await CityStore.shared.city(covering: [start.coordinate, end.coordinate])
        guard city.covers(start.coordinate), city.covers(end.coordinate) else { throw WalkError.outsideNetwork }
        try Task.checkCancellation()
        let graph = city.bundle.graph
        let router = WalkRouter(graph: graph)
        let a = try router.snap(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude)
        let b = try router.snap(latitude: end.coordinate.latitude, longitude: end.coordinate.longitude)
        let sun = Solar.position(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude, date: date)
        var scorer = SunScorer(buildings: city.bundle.buildings)
        var stamp: Int32 = 0
        let routes = try router.routes(from: a, to: b) { edge in
            try Task.checkCancellation()
            let i = Int(edge), u = Int(graph.edgeA[i]), v = Int(graph.edgeB[i])
            stamp += 6
            return Double(scorer.score(aLat: graph.nodeLat[u], aLon: graph.nodeLon[u],
                                       bLat: graph.nodeLat[v], bLon: graph.nodeLon[v],
                                       sun: sun, stamp: stamp))
        }
        return routes.map { route in
            WalkPreview(route: route, coordinates: route.nodes.map {
                CLLocationCoordinate2D(latitude: graph.nodeLat[Int($0)], longitude: graph.nodeLon[Int($0)])
            })
        }
    }
}

@MainActor
final class WalkPlanner: ObservableObject {
    @Published var start: WalkPlace?
    @Published var end: WalkPlace?
    @Published var previews: [WalkPreview] = []
    @Published var selected: WalkKind = .balanced
    @Published var isComputing = false
    @Published var error: String?
    @Published var version = 0
    @Published var fitRequest = 0
    private let service = WalkService()
    private var task: Task<Void, Never>?

    var sharedPaths: Bool {
        !previews.isEmpty && Set(previews.map { $0.route.edges }).count < previews.count
    }

    func set(_ place: WalkPlace, asStart: Bool, date: Date) {
        if asStart { start = place } else { end = place }
        refresh(date: date, fit: true)
    }

    func refresh(date: Date, fit: Bool = false) {
        task?.cancel()
        previews = []
        version += 1
        error = nil
        guard let start, let end else { isComputing = false; return }
        isComputing = true
        task = Task {
            do {
                try await Task.sleep(nanoseconds: 200_000_000)
                let result = try await service.routes(from: start, to: end, date: date)
                try Task.checkCancellation()
                previews = result
                if !result.contains(where: { $0.id == selected }) { selected = .fastest }
                version += 1
                if fit { fitRequest += 1 }
                isComputing = false
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                self.error = error.localizedDescription
                isComputing = false
            }
        }
    }

    func select(_ kind: WalkKind) {
        selected = kind
        version += 1
    }
}

/// Adapted from Like Water's PlaceSearch: native place lookup, never fetched route geometry.
@MainActor
final class WalkPlaceSearch: NSObject, ObservableObject {
    @Published var results: [WalkPlace] = []
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var error: String?
    @Published var isSearching = false
    private var search: MKLocalSearch?
    private let completer = MKLocalSearchCompleter()
    private var generation = 0

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .address]
        completer.region = MKCoordinateRegion(center: SunMapModel.fallbackCenter,
                                              latitudinalMeters: 15_000, longitudinalMeters: 15_000)
    }

    func updateQuery(_ text: String) {
        generation += 1
        search?.cancel()
        isSearching = false
        results = []
        suggestions = []
        error = nil
        completer.queryFragment = text
    }

    func resolve(_ completion: MKLocalSearchCompletion) async -> WalkPlace? {
        let token = generation
        isSearching = true
        defer { if token == generation { isSearching = false } }
        let lookup = MKLocalSearch(request: MKLocalSearch.Request(completion: completion))
        search?.cancel()
        search = lookup
        do {
            let response = try await lookup.start()
            guard token == generation, let item = response.mapItems.first else { return nil }
            return WalkPlace(name: item.name ?? completion.title, coordinate: item.placemark.coordinate,
                             subtitle: completion.subtitle)
        } catch {
            guard token == generation else { return nil }
            self.error = "Place search failed: \(error.localizedDescription)"
            return nil
        }
    }

    func find(_ text: String) async {
        generation += 1
        let token = generation
        search?.cancel()
        results = []
        suggestions = []
        error = nil
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        let pair = query.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        if pair.count == 2, (-90...90).contains(pair[0]), (-180...180).contains(pair[1]) {
            results = [WalkPlace(name: query, coordinate: CLLocationCoordinate2D(latitude: pair[0], longitude: pair[1]))]
            return
        }
        isSearching = true
        defer { if token == generation { isSearching = false } }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: SunMapModel.fallbackCenter,
                                            latitudinalMeters: 15_000, longitudinalMeters: 15_000)
        let lookup = MKLocalSearch(request: request)
        search = lookup
        do {
            let response = try await lookup.start()
            guard !Task.isCancelled, token == generation else { return }
            results = response.mapItems.map {
                WalkPlace(name: $0.name ?? query, coordinate: $0.placemark.coordinate,
                          subtitle: $0.placemark.title ?? "")
            }
            if results.isEmpty { error = "No places found. Try a street address in San Francisco." }
        } catch {
            guard !Task.isCancelled, token == generation else { return }
            self.error = "Place search failed: \(error.localizedDescription)"
        }
    }
}

extension WalkPlaceSearch: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = Array(completer.results.prefix(6))
        Task { @MainActor in self.suggestions = results }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let message = error.localizedDescription
        Task { @MainActor in
            self.suggestions = []
            self.error = "Suggestions unavailable: \(message). Press Search to try a full lookup."
        }
    }
}

struct WalkEndpointBar: View {
    let location: CLLocationCoordinate2D?
    let onPick: (WalkPlace, Bool) -> Void
    let onEditingChange: (Bool) -> Void
    @StateObject private var search = WalkPlaceSearch()
    @State private var startText = ""
    @State private var endText = ""
    @FocusState private var focused: Endpoint?
    private enum Endpoint: Hashable { case start, end }

    private var query: String { focused == .start ? startText : endText }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "circle").foregroundStyle(.blue)
                TextField("Starting point", text: $startText)
                    .accessibilityIdentifier("walkStartInput")
                    .focused($focused, equals: .start)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit { Task { await search.find(startText) } }
                if focused == .start, !startText.isEmpty {
                    Button { startText = "" } label: { Image(systemName: "xmark.circle.fill") }
                        .accessibilityLabel("Clear starting point")
                        .accessibilityIdentifier("clearStartInput")
                }
            }
            .padding(12)
            Divider().padding(.leading, 38)
            HStack(spacing: 10) {
                Image(systemName: "mappin.circle.fill").foregroundStyle(.red)
                TextField("Destination", text: $endText)
                    .accessibilityIdentifier("walkEndInput")
                    .focused($focused, equals: .end)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit { Task { await search.find(endText) } }
                if focused == .end, !endText.isEmpty {
                    Button { endText = "" } label: { Image(systemName: "xmark.circle.fill") }
                        .accessibilityLabel("Clear destination")
                        .accessibilityIdentifier("clearEndInput")
                }
            }
            .padding(12)
            if focused != nil {
                Divider()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if let location, focused == .start {
                            Button("Use my location") {
                                choose(WalkPlace(name: "My location", coordinate: location))
                            }.padding(12)
                        }
                        if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Button {
                                Task { await search.find(query) }
                            } label: {
                                Label("Search San Francisco", systemImage: "magnifyingglass")
                            }
                            .accessibilityIdentifier("searchPlaces")
                            .padding(12)
                        }
                        if search.isSearching { ProgressView("Searching…").padding(12) }
                        if let error = search.error {
                            Text(error).font(.caption).foregroundStyle(.red).padding(12)
                        }
                        ForEach(search.results) { place in
                            Button { choose(place) } label: {
                                resultLabel(place.name, subtitle: place.subtitle)
                            }
                            .accessibilityIdentifier("placeResult")
                        }
                        if search.results.isEmpty {
                            ForEach(Array(search.suggestions.enumerated()), id: \.offset) { _, completion in
                                Button {
                                    Task {
                                        if let place = await search.resolve(completion) { choose(place) }
                                    }
                                } label: {
                                    resultLabel(completion.title, subtitle: completion.subtitle)
                                }
                                .accessibilityIdentifier("placeSuggestion")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: 230)
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 10)
        .onChange(of: startText) { _, value in
            if focused == .start { search.updateQuery(value) }
        }
        .onChange(of: endText) { _, value in
            if focused == .end { search.updateQuery(value) }
        }
        .onChange(of: focused) { _, _ in
            search.updateQuery(focused == nil ? "" : query)
            onEditingChange(focused != nil)
        }
    }

    private func resultLabel(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.subheadline.weight(.medium))
            if !subtitle.isEmpty {
                Text(subtitle).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .contentShape(Rectangle())
    }

    private func choose(_ place: WalkPlace) {
        let isStart = focused == .start
        focused = nil
        if isStart { startText = place.name } else { endText = place.name }
        search.updateQuery("")
        onPick(place, isStart)
    }
}

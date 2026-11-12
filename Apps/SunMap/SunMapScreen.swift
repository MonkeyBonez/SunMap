import SwiftUI
import MapKit
import SunMapEngine

struct SunMapScreen: View {
    @StateObject private var model = SunMapModel()
    @StateObject private var walks = WalkPlanner()
    @State private var editingEndpoint = false
    @ObservedObject private var loadState = CityLoadState.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            SunMapMapView(model: model, walks: walks)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                if !editingEndpoint { panel }
            }
        }
        .overlay(alignment: .top) {
            VStack(spacing: 6) {
                WalkEndpointBar(location: model.location.coordinate, onPick: { place, isStart in
                    model.userMovedMap = true
                    walks.set(place, asStart: isStart, date: model.selectedDate)
                }, onEditingChange: { editingEndpoint = $0 })
                if !editingEndpoint { topStatus }
            }
            .padding(.top, 8)
        }
        .onReceive(model.location.$coordinate.compactMap { $0 }) { model.onLocationUpdate($0) }
        .onChange(of: model.selectedDate) { _, date in walks.refresh(date: date) }
        .onAppear {
            if model.center == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { model.useFallbackCenter() }
            } else {
                model.recompute(force: true)
            }
        }
    }

    @ViewBuilder private var topStatus: some View {
        VStack(spacing: 6) {
            if let error = model.error {
                Text(error)
                    .font(.caption).foregroundStyle(.white)
                    .padding(10)
                    .background(Color.red.opacity(0.9), in: RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
            }
            if let message = loadState.message {
                HStack(spacing: 8) {
                    if let p = loadState.progress { ProgressView(value: p).frame(width: 90) } else { ProgressView() }
                    Text(message).font(.caption)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .accessibilityIdentifier("cityLoadStatus")
            } else if model.field == nil && model.error == nil && model.notCovered == nil {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Loading city…").font(.caption)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
            }
            if model.notCovered != nil {
                VStack(spacing: 6) {
                    Text("No sun data here yet").font(.subheadline.weight(.semibold))
                    if let detail = model.coverageDetail {
                        Text(detail).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                    if model.canRequestCoverage {
                        Button(model.requestSent ? "Requested — thanks" : "Request this area") { model.requestCoverage() }
                            .buttonStyle(.borderedProminent).font(.caption)
                            .disabled(model.requestSent)
                            .accessibilityIdentifier("requestCoverageButton")
                    }
                }
                .padding(12)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("coverageBanner")
            }
            if !model.status.isEmpty {
                Text(model.status)
                    .font(.footnote.weight(.medium))
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(.ultraThinMaterial, in: Capsule())
                    .accessibilityIdentifier("sunStatus")
            }
        }
        .padding(.top, 8)
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: 10) {
            walkControls
            HStack(alignment: .firstTextBaseline) {
                Text(model.timeText)
                    .font(.title2.weight(.semibold).monospacedDigit())
                    .accessibilityIdentifier("sunTime")
                Text(model.readout)
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("sunReadout")
                Spacer()
                Button("Now") { model.resetToNow() }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("nowButton")
            }

            if let window = model.daylight {
                HStack(spacing: 8) {
                    Button { model.stepMinutes(-15) } label: { Image(systemName: "minus.circle") }
                        .accessibilityIdentifier("stepBack")
                    Slider(value: Binding(
                        get: { model.selectedDate.timeIntervalSince1970 },
                        set: { model.setDate(Date(timeIntervalSince1970: ($0 / 900).rounded() * 900)) }),
                           in: window.sunrise.timeIntervalSince1970...window.sunset.timeIntervalSince1970)
                    .accessibilityIdentifier("timeScrubber")
                    Button { model.stepMinutes(15) } label: { Image(systemName: "plus.circle") }
                        .accessibilityIdentifier("stepForward")
                }
                .buttonStyle(.borderless)
                HStack {
                    Text(short(window.sunrise)); Spacer(); Text(short(window.sunset))
                }
                .font(.caption2).foregroundStyle(.secondary)
            }

            legend

            Text("Clear sky · sidewalk sunlight at selected time · ETA at 1.4 m/s")
                .font(.caption2).foregroundStyle(.secondary)
                .accessibilityIdentifier("clearSkyNote")

            if let field = model.field {
                Text(Self.statsLine(field, beam: model.beamStrength))
                    .font(.caption2.monospaced())
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("sunStats")
                    .accessibilityValue(String(format: "%.4f,%.4f · stitch %@", field.center.latitude, field.center.longitude, field.stitchID))
            }

        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(10)
    }

    private var walkControls: some View {
        VStack(spacing: 8) {
            if walks.isComputing {
                ProgressView("Finding sunny walks…").font(.caption)
                    .accessibilityIdentifier("walkProgress")
            }
            if let error = walks.error {
                Text(error).font(.caption).foregroundStyle(.red)
                    .accessibilityIdentifier("walkError")
            }
            HStack(spacing: 6) {
                ForEach(walks.previews) { preview in
                    let kind = preview.route.kind
                    Button { walks.select(kind) } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 4) {
                                Circle().fill(Color(kind.color)).frame(width: 7, height: 7)
                                Text(kind.rawValue).font(.caption.weight(.semibold))
                            }
                            Text("\(preview.route.minutes) min").font(.headline.monospacedDigit())
                            Text("\(preview.route.sunPercent)% sunlight")
                                .font(.caption.monospacedDigit())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(9)
                        .background(Color(kind.color).opacity(walks.selected == kind ? 0.18 : 0.05),
                                    in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(kind.color), lineWidth: walks.selected == kind ? 2 : 0.5))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("route\(kind.rawValue)")
                    .accessibilityLabel("\(kind.rawValue), \(preview.route.minutes) minutes, \(preview.route.sunPercent) percent sunlight")
                    .accessibilityAddTraits(walks.selected == kind ? .isSelected : [])
                }
            }
            if walks.sharedPaths {
                Text("Some options share the same best path at this time.")
                    .font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    /// One line the UI tests read: what was scored, how, from where.
    static func statsLine(_ field: SunField, beam: Double) -> String {
        let f = NumberFormatter(); f.numberStyle = .decimal
        let n = { (v: Int) in f.string(from: NSNumber(value: v)) ?? "\(v)" }
        var where_ = field.city
        if field.stitchedTiles > 0 {
            where_ += " (\(field.stitchedTiles) tiles\(field.downloaded > 0 ? ", \(field.downloaded) downloaded" : ""))"
        }
        let how = field.detail.isBlocks
            ? "\(n(field.cellCount)) blocks from \(n(field.scoredEdges)) edges scored"
            : "\(n(field.scoredEdges)) edges scored"
        var line = "\(where_) · \(how) in \(String(format: "%.0f", field.computeMs)) ms"
        line += " (\(field.tiles.count) score tiles, \(field.cachedTiles) cached\(field.inProgress ? ", scoring…" : ""))"
        line += " · \(n(field.sunnyCount)) sunny / \(n(field.mixedCount)) mixed / \(n(field.shadedCount)) shaded"
        line += " · sky \(String(format: "%.2f", beam)) \(field.skySource)"
        if let b = field.built { line += " · build " + MetroIndex.buildKey(b) }
        line += " · cache \(field.cacheBytes / 1_000_000) MB"
        return line
    }

    private var legend: some View {
        let p = SkyPalette.colors(beam: model.beamStrength)
        return HStack(spacing: 14) {
            swatch(Color(p.sun), "Sun")
            swatch(Color(p.mixed), "Mixed")
            swatch(Color(p.shade), "Shade")
        }
        .font(.caption2).foregroundStyle(.secondary)
    }

    private func swatch(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            Capsule().fill(color).frame(width: 18, height: 4)
            Text(label)
        }
    }

    private func short(_ date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "h:mm a"
        f.timeZone = model.cityTimeZone
        return f.string(from: date)
    }
}

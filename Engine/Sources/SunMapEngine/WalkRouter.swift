import Foundation

public enum WalkKind: String, CaseIterable, Identifiable, Sendable {
    case fastest = "Fastest", balanced = "Balanced", sunniest = "Sunniest"
    public var id: String { rawValue }
}

public struct WalkRoute: Sendable {
    public let kind: WalkKind
    public let nodes: [Int32]
    public let edges: [Int32]
    public let metres: Double
    public let sunFraction: Double
    /// A consistent 1.4 m/s walking estimate, not live navigation or traffic.
    public var minutes: Int { max(1, Int((metres / 1.4 / 60).rounded())) }
    public var sunPercent: Int { Int((sunFraction * 100).rounded()) }
}

public enum WalkError: Error, LocalizedError {
    case outsideNetwork, samePoint, noPath

    public var errorDescription: String? {
        switch self {
        case .outsideNetwork: return "Choose endpoints within 150 m of the built public walking network."
        case .samePoint: return "Choose a destination farther from your starting point."
        case .noPath: return "No public walking route connects these points in the built data."
        }
    }
}

/// Searches the built graph only. Sun alternatives are sampled weighted shortest
/// paths, with detours capped at 75%. Balanced is an optional Pareto middle ground.
public struct WalkRouter {
    public let graph: PedestrianGraph
    public init(graph: PedestrianGraph) { self.graph = graph }

    public func snap(latitude: Double, longitude: Double) throws -> Int32 {
        guard latitude.isFinite, longitude.isFinite,
              graph.bbox.contains(lat: latitude, lon: longitude) else { throw WalkError.outsideNetwork }
        let nearby = graph.edges(near: latitude, lon: longitude, radius: 150)
        let nodes = Set(nearby.filter { !graph.isPrivate(Int($0)) }.flatMap {
            [graph.edgeA[Int($0)], graph.edgeB[Int($0)]]
        })
        let best = nodes.filter { graph.isNetworkComponent(graph.component[Int($0)]) }.min {
            distance($0, latitude, longitude) < distance($1, latitude, longitude)
        }
        guard let best, distance(best, latitude, longitude) <= 150 else { throw WalkError.outsideNetwork }
        return best
    }

    private func distance(_ node: Int32, _ lat: Double, _ lon: Double) -> Double {
        haversineMeters(graph.nodeLat[Int(node)], graph.nodeLon[Int(node)], lat, lon)
    }

    public func routes(from start: Int32, to end: Int32,
                       sunlight: (Int32) throws -> Double) throws -> [WalkRoute] {
        guard start >= 0, end >= 0, Int(start) < graph.nodeCount, Int(end) < graph.nodeCount else {
            throw WalkError.outsideNetwork
        }
        guard start != end else { throw WalkError.samePoint }
        var scores: [Int32: Double] = [:]
        func score(_ edge: Int32) throws -> Double {
            if let cached = scores[edge] { return cached }
            let value = try sunlight(edge)
            let clamped = min(1, max(0, value))
            scores[edge] = clamped
            return clamped
        }
        guard let shortest = try path(from: start, to: end, weight: 0, score: score) else {
            throw WalkError.noPath
        }
        func length(_ path: Path) -> Double { path.edges.reduce(0) { $0 + graph.edgeLen[Int($1)] } }
        func fraction(_ path: Path) throws -> Double {
            let sidewalks = path.edges.filter { !graph.isCrossing(Int($0)) }
            let lit = try sidewalks.reduce(0.0) { try $0 + graph.edgeLen[Int($1)] * score($1) }
            let metres = sidewalks.reduce(0.0) { $0 + graph.edgeLen[Int($1)] }
            return lit / max(0.001, metres)
        }
        let fastestLength = length(shortest)
        var candidates = [shortest]
        for weight in [0.1, 0.2, 0.3, 0.4, 0.6, 0.8, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0, 9.0] {
            try Task.checkCancellation()
            if let candidate = try path(from: start, to: end, weight: weight,
                                        limit: fastestLength * 1.75, score: score),
               length(candidate) <= fastestLength * 1.75 + 0.001,
               !candidates.contains(where: { $0.edges == candidate.edges }) {
                candidates.append(candidate)
            }
        }
        let measured = try candidates.map { path in
            WalkRoute(kind: .fastest, nodes: path.nodes, edges: path.edges,
                      metres: length(path), sunFraction: try fraction(path))
        }
        return Self.choices(fastest: measured[0], candidates: measured)
    }

    static func choices(fastest: WalkRoute, candidates: [WalkRoute]) -> [WalkRoute] {
        let frontier = candidates.filter { route in
            !candidates.contains { other in
                other.metres <= route.metres && other.sunFraction >= route.sunFraction &&
                (other.metres < route.metres || other.sunFraction > route.sunFraction)
            }
        }
        let sunniest = frontier.sorted {
            if $0.sunFraction != $1.sunFraction { return $0.sunFraction > $1.sunFraction }
            return $0.metres < $1.metres
        }.first ?? fastest
        // Require a visible benefit in the rounded card values, not just a
        // sub-second or sub-percent difference hidden from the walker.
        let middle = frontier.filter {
            $0.metres < sunniest.metres && $0.sunFraction > fastest.sunFraction &&
            $0.minutes < sunniest.minutes && $0.sunPercent > fastest.sunPercent
        }
        func compromise(_ route: WalkRoute) -> Double {
            let extraTime = (route.metres - fastest.metres) / max(0.001, sunniest.metres - fastest.metres)
            let lostSun = (sunniest.sunFraction - route.sunFraction) / max(0.0001, sunniest.sunFraction - fastest.sunFraction)
            return extraTime * extraTime + lostSun * lostSun
        }
        let balanced = middle.min {
            let a = compromise($0), b = compromise($1)
            return a == b ? $0.metres < $1.metres : a < b
        }
        func labelled(_ route: WalkRoute, _ kind: WalkKind) -> WalkRoute {
            WalkRoute(kind: kind, nodes: route.nodes, edges: route.edges,
                      metres: route.metres, sunFraction: route.sunFraction)
        }
        var choices = [labelled(fastest, .fastest)]
        if let balanced { choices.append(labelled(balanced, .balanced)) }
        choices.append(labelled(sunniest, .sunniest))
        return choices
    }

    private struct Path {
        let nodes: [Int32]
        let edges: [Int32]
    }

    private func path(from start: Int32, to end: Int32, weight: Double,
                      limit: Double = .infinity,
                      score: (Int32) throws -> Double) throws -> Path? {
        var costs = [Double](repeating: .infinity, count: graph.nodeCount)
        var previous = [Int32](repeating: -1, count: graph.nodeCount)
        var previousEdge = previous
        var heap = MinHeap()
        costs[Int(start)] = 0
        heap.push(node: start, cost: 0)
        var visits = 0
        while let item = heap.pop() {
            let u = Int(item.node)
            if item.cost > costs[u] { continue }
            visits += 1
            if visits % 256 == 0 { try Task.checkCancellation() }
            if item.node == end {
                var nodes = [end], edges: [Int32] = []
                var v = end
                while v != start {
                    edges.append(previousEdge[Int(v)])
                    v = previous[Int(v)]
                    nodes.append(v)
                }
                return Path(nodes: nodes.reversed(), edges: edges.reversed())
            }
            for k in Int(graph.adjStart[u])..<Int(graph.adjStart[u + 1]) {
                let edge = graph.adjEdge[k], e = Int(edge), v = graph.adjNode[k]
                if graph.isPrivate(e) { continue }
                // Every route through v is at least this long; avoid scoring the
                // rest of the city for a short walk.
                if limit.isFinite {
                    let lowerBound = distance(v, graph.nodeLat[Int(start)], graph.nodeLon[Int(start)])
                        + distance(v, graph.nodeLat[Int(end)], graph.nodeLon[Int(end)])
                    if lowerBound > limit { continue }
                }
                // Like Water's route cost never rewards a sunny crossing: doing
                // that made routes zigzag across the road to harvest sunlight.
                let shade = weight == 0 ? 0 : graph.isCrossing(e) ? 1 : 1 - (try score(edge))
                let cost = item.cost + graph.edgeLen[e] * (1 + weight * shade)
                if cost < costs[Int(v)] {
                    costs[Int(v)] = cost
                    previous[Int(v)] = item.node
                    previousEdge[Int(v)] = edge
                    heap.push(node: v, cost: cost)
                }
            }
        }
        return nil
    }

    private struct MinHeap {
        struct Item { let node: Int32; let cost: Double }
        var items: [Item] = []
        mutating func push(node: Int32, cost: Double) {
            items.append(Item(node: node, cost: cost))
            var i = items.count - 1
            while i > 0 {
                let parent = (i - 1) / 2
                guard items[i].cost < items[parent].cost else { break }
                items.swapAt(i, parent)
                i = parent
            }
        }
        mutating func pop() -> Item? {
            guard !items.isEmpty else { return nil }
            if items.count == 1 { return items.removeLast() }
            let result = items[0]
            items[0] = items.removeLast()
            var i = 0
            while i * 2 + 1 < items.count {
                let left = i * 2 + 1, right = left + 1
                let child = right < items.count && items[right].cost < items[left].cost ? right : left
                guard items[child].cost < items[i].cost else { break }
                items.swapAt(child, i)
                i = child
            }
            return result
        }
    }
}

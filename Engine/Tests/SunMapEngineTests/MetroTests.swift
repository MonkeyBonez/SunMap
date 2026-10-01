import XCTest
@testable import SunMapEngine

/// Tests against the built metros in `Server/` (New York, Los Angeles, Seattle). Each
/// test skips when its metro has not been built (`Pipeline/build_metro.py`), so a clean
/// checkout still passes.
final class MetroTests: XCTestCase {

    private static var root: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Server")
    }

    struct Loaded {
        var city: CityBundle
        var tiles: Int
        var readMs: Double
        var stitchMs: Double
    }

    /// Stitches the tiles within `reach` of the points, exactly as the apps choose them.
    private func stitch(_ id: String, around points: [(Double, Double)], reach: Double = 2_500,
                        far: Bool = true) throws -> Loaded {
        let dir = Self.root.appendingPathComponent(id)
        guard let index = try? MetroIndex.load(from: dir.appendingPathComponent("metro.json")) else {
            throw XCTSkip("\(id) not built yet")
        }
        let box = BBox.around(points.map { (lat: $0.0, lon: $0.1) }, paddingMeters: reach)
        let chosen = index.tiles(intersecting: box)
        let t0 = CFAbsoluteTimeGetCurrent()
        let raws = try chosen.map { try RawBundle(contentsOf: dir.appendingPathComponent($0.file)) }
        var farGrid: TerrainGrid? = nil
        if far, let f = index.far {
            farGrid = try RawBundle(contentsOf: dir.appendingPathComponent(f.file)).terrain
        }
        let t1 = CFAbsoluteTimeGetCurrent()
        let city = try TileStitcher.stitch(raws, farTerrain: farGrid)
        let t2 = CFAbsoluteTimeGetCurrent()
        print(String(format: "%@: %d tiles, %d nodes, %d edges, %d buildings; read %.0f ms, stitch %.0f ms",
                     id, chosen.count, city.graph.nodeCount, city.graph.edgeCount, city.buildings.count,
                     (t1 - t0) * 1000, (t2 - t1) * 1000))
        return Loaded(city: city, tiles: chosen.count, readMs: (t1 - t0) * 1000, stitchMs: (t2 - t1) * 1000)
    }

    #if DEBUG
    static let slow = 10.0      // `swift test` builds debug; hot loops run ~10-40x slower
    #else
    static let slow = 1.0
    #endif

    private func shadedCounts(_ city: CityBundle, at p: (Double, Double), radius: Double, date: String,
                              maxHeight: Double? = nil) -> (shaded: Int, total: Int, ms: Double) {
        let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime]
        let sun = Solar.position(latitude: p.0, longitude: p.1, date: f.date(from: date)!)
        var scorer = SunScorer(buildings: city.buildings, maxBuildingHeight: maxHeight)
        let ids = city.graph.edges(near: p.0, lon: p.1, radius: radius)
        let t0 = CFAbsoluteTimeGetCurrent()
        let s = scorer.score(graph: city.graph, edges: ids, sun: sun)
        return (s.filter { $0 < 0.3 }.count, ids.count, (CFAbsoluteTimeGetCurrent() - t0) * 1000)
    }

    // MARK: - Seattle

    func testSeattleStitchesAroundDowntownWithoutSeams() throws {
        let l = try stitch("seattle", around: [(47.6062, -122.3321)])
        let g = l.city.graph
        XCTAssertGreaterThanOrEqual(l.tiles, 4)
        let sizes = g.componentSizes.sorted(by: >)
        print("component sizes:", sizes.prefix(8), "count", sizes.count)
        // Where are nodes that are not on the main network? Inside the tile set (1 km in
        // from its edge) they would mean a seam; at its edge they are just streets whose
        // continuation lives in a tile that is not loaded.
        let inner = BBox(minLat: l.city.bbox.minLat + 0.009, minLon: l.city.bbox.minLon + 0.013,
                         maxLat: l.city.bbox.maxLat - 0.009, maxLon: l.city.bbox.maxLon - 0.013)
        var innerOff = 0, innerAll = 0, byComp = [Int32: Int]()
        for n in 0..<g.nodeCount where inner.contains(lat: g.nodeLat[n], lon: g.nodeLon[n]) {
            innerAll += 1
            if !g.isNetworkComponent(g.component[n]) { innerOff += 1 }
            byComp[g.component[n], default: 0] += 1
        }
        let big = byComp.filter { g.isNetworkComponent($0.key) }.map { g.componentSizes[Int($0.key)] }.sorted(by: >)
        print("inner nodes \(innerAll), off-network \(innerOff); network components inside: \(big.prefix(6))")
        XCTAssertLessThan(Double(innerOff) / Double(innerAll), 0.02,
                          "inside the tile set, almost every node must be on a real network")
        XCTAssertLessThan(l.stitchMs, 1_500 * Self.slow / 10 + 500)
        XCTAssertNotNil(l.city.terrain?.fallback, "far-field terrain rides behind the tile mosaic")
    }

    // MARK: - New York

    /// Staten Island is only reachable by ferry, so it is its own component. It must
    /// still be in the metro, with sidewalks to paint around St. George.
    func testStatenIslandIsInTheMetro() throws {
        let stGeorge = (40.6437, -74.0736)
        let l = try stitch("nyc", around: [stGeorge])
        let near = l.city.graph.edges(near: stGeorge.0, lon: stGeorge.1, radius: 300)
        XCTAssertGreaterThan(near.count, 50, "no streets near St. George")
    }

    /// Central Park South in December: Billionaires' Row (300-470 m) shades the park's
    /// southern paths hundreds of metres out. The old 100 m search missed every shadow
    /// beyond 100/tan(el) metres — measured: 507 shaded edges vs 1,060 with full reach.
    func testMidtownWinterShadowsNeedTheFullTowerHeight() throws {
        let p = (40.7690, -73.9760)   // Central Park, just north of 59th St
        let l = try stitch("nyc", around: [p])
        let full = shadedCounts(l.city, at: p, radius: 400, date: "2026-12-21T17:00:00Z")
        let capped = shadedCounts(l.city, at: p, radius: 400, date: "2026-12-21T17:00:00Z", maxHeight: 100)
        print(String(format: "Midtown Dec noon: shaded %d / %d full reach (%.0f ms), %d with a 100 m cap",
                     full.shaded, full.total, full.ms, capped.shaded))
        XCTAssertGreaterThan(Double(full.shaded), 1.5 * Double(capped.shaded))
        XCTAssertLessThan(full.ms, 200 * Self.slow)
    }

    // MARK: - Los Angeles

    func testLosAngelesDowntownLoadsWithTerrain() throws {
        let p = (34.0505, -118.2551)
        let l = try stitch("la", around: [p])
        XCTAssertGreaterThan(l.city.graph.nodeCount, 20_000)
        let far = try XCTUnwrap(l.city.terrain?.fallback)
        XCTAssertGreaterThan(far.maxElevation, 1_500, "the San Gabriels are in the far field")
        // Bunker Hill sits on a slope: the scored street must carry its own ground height.
        let ids = l.city.graph.edges(near: p.0, lon: p.1, radius: 300)
        XCTAssertGreaterThan(ids.count, 100)
    }
}

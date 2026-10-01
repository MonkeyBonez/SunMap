import Foundation
import SunMapEngine

// Dumps what the engine computes as GeoJSON, so the Folium check in
// Pipeline/check_maps.py renders exactly the app's own numbers rather than a
// second implementation that could agree by luck.
//
//   suntool sun      --center LAT,LON --radius 400 --at 2026-09-23T17:00:00Z --out file.geojson

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data((message + "\n").utf8))
    exit(1)
}

func option(_ name: String) -> String? {
    guard let i = CommandLine.arguments.firstIndex(of: "--\(name)"),
          i + 1 < CommandLine.arguments.count else { return nil }
    return CommandLine.arguments[i + 1]
}

func coordinate(_ raw: String?, _ label: String) -> (lat: Double, lon: Double) {
    guard let parts = raw?.split(separator: ",").compactMap({ Double($0.trimmingCharacters(in: .whitespaces)) }),
          parts.count == 2 else { fail("--\(label) needs LAT,LON") }
    return (parts[0], parts[1])
}

// `suntool sky` needs no bundle: it asks Open-Meteo for the cells around a point and
// prints what the app would say, so a forecast claim can be checked from the terminal.
//   suntool sky --center LAT,LON [--at ISO8601] [--json file]
if CommandLine.arguments.count > 1, CommandLine.arguments[1] == "sky" {
    let c = coordinate(option("center"), "center")
    let when: Date = {
        guard let raw = option("at") else { return Date() }
        let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime]
        guard let d = f.date(from: raw) else { fail("--at needs ISO 8601, e.g. 2026-09-23T20:00:00Z") }
        return d
    }()
    let points = OpenMeteoSky.latticePoints(around: c.lat, longitude: c.lon)
    let field: SkyField
    if let path = option("json") {
        field = try OpenMeteoSky.decode(try Data(contentsOf: URL(fileURLWithPath: path)))
    } else {
        let url = OpenMeteoSky.requestURL(points: points)
        print("GET \(url.absoluteString)")
        let t0 = Date()
        let sem = DispatchSemaphore(value: 0)
        var got: Data?; var status = -1; var failure: Error?
        var request = URLRequest(url: url); request.setValue("suntool/0.1", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { data, response, error in
            got = data; failure = error; status = (response as? HTTPURLResponse)?.statusCode ?? -1
            sem.signal()
        }.resume()
        sem.wait()
        guard let data = got else { fail("fetch failed: \(failure.map { "\($0)" } ?? "?")") }
        print("HTTP \(status), \(data.count) bytes, \(Int(Date().timeIntervalSince(t0) * 1000)) ms")
        field = try OpenMeteoSky.decode(data)
    }
    let sun = Solar.position(latitude: c.lat, longitude: c.lon, date: when)
    print("cells: \(field.samples.count) distinct of \(points.count) requested; \(field.samples.first?.times.count ?? 0) 15-min steps each")
    if !sun.isUp { print("note: sun is below the horizon at that time; beam is 0 regardless of cloud") }
    print(String(format: "sun at %@: az %.1f° el %.1f°  clear-sky DNI %.0f W/m²",
                 ISO8601DateFormatter().string(from: when), sun.azimuth, sun.elevation,
                 ClearSky.directNormal(elevation: sun.elevation)))
    for s in field.samples.sorted(by: { haversineMeters(c.lat, c.lon, $0.latitude, $0.longitude) < haversineMeters(c.lat, c.lon, $1.latitude, $1.longitude) }) {
        let d = haversineMeters(c.lat, c.lon, s.latitude, s.longitude)
        if let cond = s.condition(at: when, sunElevation: sun.elevation) {
            print(String(format: "  cell %.4f,%.4f  %4.0f m  dni %4.0f dif %4.0f cloud %3.0f%% low %3.0f%%  beam %.2f  %@",
                         s.latitude, s.longitude, d, cond.directNormal, cond.diffuse,
                         cond.cloudCover * 100, cond.lowCloud * 100, cond.beamStrength, cond.summary))
        } else {
            print(String(format: "  cell %.4f,%.4f  %4.0f m  (no data at that time)", s.latitude, s.longitude, d))
        }
    }
    if let here = field.condition(latitude: c.lat, longitude: c.lon, at: when, sunElevation: sun.elevation) {
        print(String(format: "here: beam %.2f -> %@", here.beamStrength, here.summary))
    }
    if let spread = field.beamSpread(at: when, sunElevation: sun.elevation) {
        print(String(format: "spread across cells: %.2f … %.2f%@", spread.min, spread.max,
                     spread.max - spread.min >= 0.4 ? "  (two weathers)" : ""))
    }
    exit(0)
}

/// A single bundle (`--bundle`), or a metro (`--metro Server/nyc`) stitched from the
/// tiles within `--reach` metres (default 2500, as the app does) of the points given.
/// `--no-far` drops the far-field terrain, the baseline for "what do distant hills add".
func loadCity() throws -> CityBundle {
    if let dir = option("metro") {
        let base = URL(fileURLWithPath: dir)
        guard let index = try? MetroIndex.load(from: base.appendingPathComponent("metro.json")) else {
            fail("no metro.json in \(dir)")
        }
        let pts = ["center"].compactMap { option($0) }.map { coordinate($0, "point") }
        guard !pts.isEmpty else { fail("--metro needs --center") }
        let reach = Double(option("reach") ?? "2500") ?? 2500
        let box = BBox.around(pts.map { ($0.lat, $0.lon) }, paddingMeters: reach)
        let chosen = index.tiles(intersecting: box)
        guard !chosen.isEmpty else { fail("no tiles near those points") }
        let t0 = CFAbsoluteTimeGetCurrent()
        let raws = try chosen.map { try RawBundle(contentsOf: base.appendingPathComponent($0.file)) }
        let t1 = CFAbsoluteTimeGetCurrent()
        var far: TerrainGrid? = nil
        if !CommandLine.arguments.contains("--no-far"), let f = index.far {
            far = try RawBundle(contentsOf: base.appendingPathComponent(f.file)).terrain
        }
        let city = try TileStitcher.stitch(raws, farTerrain: far)
        let t2 = CFAbsoluteTimeGetCurrent()
        let bytes = chosen.reduce(0) { $0 + $1.bytes }
        FileHandle.standardError.write(Data(String(format: "stitched %d tiles (%.1f MB): %d nodes, %d edges, %d buildings; read %.0f ms, stitch %.0f ms\n",
            chosen.count, Double(bytes) / 1e6, city.graph.nodeCount, city.graph.edgeCount,
            city.buildings.count, (t1 - t0) * 1000, (t2 - t1) * 1000).utf8))
        return city
    }
    let bundlePath = option("bundle") ?? FileManager.default.currentDirectoryPath + "/Resources/sanfrancisco.lwbundle"
    guard FileManager.default.fileExists(atPath: bundlePath) else { fail("no bundle at \(bundlePath)") }
    return try CityBundle(contentsOf: URL(fileURLWithPath: bundlePath))
}

let city = try loadCity()
let graph = city.graph
/// `--max-height 100` reproduces the old fixed shadow search, for before/after diffs.
let maxHeightOption = option("max-height").flatMap(Double.init)

struct Feature { var coords: [(lat: Double, lon: Double)]; var properties: [String: Any] }

func writeGeoJSON(_ features: [Feature], meta: [String: Any], to path: String) {
    var objects: [[String: Any]] = []
    for f in features {
        objects.append([
            "type": "Feature",
            "geometry": ["type": "LineString",
                         "coordinates": f.coords.map { [$0.lon, $0.lat] }],
            "properties": f.properties,
        ])
    }
    let root: [String: Any] = ["type": "FeatureCollection", "features": objects, "meta": meta]
    let data = try! JSONSerialization.data(withJSONObject: root, options: [])
    try! data.write(to: URL(fileURLWithPath: path))
    print("wrote \(path): \(features.count) features")
}

func edgeFeature(_ e: Int32, properties: [String: Any]) -> Feature {
    let a = Int(graph.edgeA[Int(e)]), b = Int(graph.edgeB[Int(e)])
    var props = properties
    props["crossing"] = graph.isCrossing(Int(e))
    props["sidewalk"] = graph.isSidewalk(Int(e))
    props["synthetic"] = graph.isSynthetic(Int(e))
    props["private"] = graph.isPrivate(Int(e))
    return Feature(coords: [(graph.nodeLat[a], graph.nodeLon[a]),
                            (graph.nodeLat[b], graph.nodeLon[b])], properties: props)
}

let command = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
let out = option("out") ?? "out.geojson"

switch command {
case "sun":
    let center = coordinate(option("center"), "center")
    let radius = Double(option("radius") ?? "400") ?? 400
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    let sun: SolarPosition
    if let az = option("azimuth").flatMap(Double.init), let el = option("elevation").flatMap(Double.init) {
        // Experiments: aim the sun by hand instead of by clock.
        sun = SolarPosition(elevation: el, azimuth: az, declination: 0, equationOfTime: 0)
    } else {
        guard let at = formatter.date(from: option("at") ?? "") else { fail("--at needs an ISO 8601 UTC time, or --azimuth/--elevation") }
        sun = Solar.position(latitude: center.lat, longitude: center.lon, date: at)
    }
    city.buildings.useTerrain = !CommandLine.arguments.contains("--no-terrain")
    var scorer = SunScorer(buildings: city.buildings, maxBuildingHeight: maxHeightOption)
    let ids = graph.edges(near: center.lat, lon: center.lon, radius: radius)
    let t0 = CFAbsoluteTimeGetCurrent()
    let scores = scorer.score(graph: graph, edges: ids, sun: sun)
    let ms = (CFAbsoluteTimeGetCurrent() - t0) * 1000
    let features = ids.enumerated().map { i, e in
        edgeFeature(e, properties: ["sun": Double(scores[i]),
                                    "bucket": SunBucket(fraction: scores[i]).rawValue])
    }
    writeGeoJSON(features, meta: [
        "azimuth": sun.azimuth, "elevation": sun.elevation, "isUp": sun.isUp,
        "at": option("at") ?? "manual", "center": [center.lat, center.lon], "radius": radius,
        "edges": ids.count, "computeMs": ms,
    ], to: out)
    var buckets = [0, 0, 0]
    for v in scores { buckets[SunBucket(fraction: v).rawValue] += 1 }
    print(String(format: "sun az %.0f el %.1f · %d edges in %.0f ms · shaded %d / mixed %d / sunny %d",
                 sun.azimuth, sun.elevation, ids.count, ms, buckets[0], buckets[1], buckets[2]))

case "sunbias":
    // Does scoring a road centreline stand in for its kerbs, or is the middle of the
    // road systematically sunnier? Takes every centreline we KNOW has sidewalks
    // (tagged sidewalk=both/left/right) and compares its own sun score against the
    // score at points offset perpendicular to it, where the kerbs actually are.
    let center = coordinate(option("center"), "center")
    let radius = Double(option("radius") ?? "600") ?? 600
    let offset = Double(option("offset") ?? "8") ?? 8
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    guard let at = formatter.date(from: option("at") ?? "") else { fail("--at needs an ISO 8601 UTC time") }
    let sun = Solar.position(latitude: center.lat, longitude: center.lon, date: at)
    var scorer = SunScorer(buildings: city.buildings, maxBuildingHeight: maxHeightOption)
    let plane = city.buildings.plane

    var pairs = 0
    var centreTotal = 0.0, kerbTotal = 0.0
    var disagreeBothKerbs = 0, kerbsDisagreeWithEachOther = 0
    var stamp: Int32 = 0

    for e in graph.edges(near: center.lat, lon: center.lon, radius: radius)
    where graph.isStreetWithSidewalkTag(Int(e)) {
        let a = Int(graph.edgeA[Int(e)]), b = Int(graph.edgeB[Int(e)])
        let pa = plane.project(lat: graph.nodeLat[a], lon: graph.nodeLon[a])
        let pb = plane.project(lat: graph.nodeLat[b], lon: graph.nodeLon[b])
        let dx = pb.x - pa.x, dy = pb.y - pa.y
        let length = (dx * dx + dy * dy).squareRoot()
        guard length > 12 else { continue }
        let nx = -dy / length * offset, ny = dx / length * offset   // perpendicular

        func score(_ ox: Double, _ oy: Double) -> Float {
            let ca = plane.unproject(x: pa.x + ox, y: pa.y + oy)
            let cb = plane.unproject(x: pb.x + ox, y: pb.y + oy)
            stamp = stamp &+ 16
            return scorer.score(aLat: ca.lat, aLon: ca.lon, bLat: cb.lat, bLon: cb.lon,
                                sun: sun, stamp: stamp)
        }

        let centre = score(0, 0)
        let left = score(nx, ny)
        let right = score(-nx, -ny)
        let kerbs = (left + right) / 2

        pairs += 1
        centreTotal += Double(centre)
        kerbTotal += Double(kerbs)
        if SunBucket(fraction: centre) != SunBucket(fraction: left)
            && SunBucket(fraction: centre) != SunBucket(fraction: right) { disagreeBothKerbs += 1 }
        if SunBucket(fraction: left) != SunBucket(fraction: right) { kerbsDisagreeWithEachOther += 1 }
    }

    guard pairs > 0 else { fail("no tagged centrelines in range") }
    print(String(format: "sun az %.0f el %.0f · %d tagged centrelines · kerb offset %.0f m",
                 sun.azimuth, sun.elevation, pairs, offset))
    print(String(format: "  centreline mean sun   %.3f", centreTotal / Double(pairs)))
    print(String(format: "  kerb mean sun         %.3f", kerbTotal / Double(pairs)))
    print(String(format: "  centreline bias       %+.3f (%+.1f%% of an edge in sun)",
                 (centreTotal - kerbTotal) / Double(pairs),
                 100 * (centreTotal - kerbTotal) / Double(pairs)))
    print(String(format: "  centreline bucket disagrees with BOTH kerbs: %d of %d (%.0f%%)",
                 disagreeBothKerbs, pairs, 100 * Double(disagreeBothKerbs) / Double(pairs)))
    print(String(format: "  the two kerbs disagree with each other:      %d of %d (%.0f%%)",
                 kerbsDisagreeWithEachOther, pairs, 100 * Double(kerbsDisagreeWithEachOther) / Double(pairs)))

case "coverage":
    // What kind of edges are around a point: the per-side sidewalk share is the number
    // that decides whether the sun layer can say which side of the street is lit.
    let center = coordinate(option("center"), "center")
    let radius = Double(option("radius") ?? "600") ?? 600
    // Length-weighted, and only over the two kinds of edge that compete for the same
    // street frontage: a sidewalk on one side, or the bare road centreline.
    var sidewalkM = 0.0, syntheticM = 0.0, streetM = 0.0
    var sidewalkN = 0, streetN = 0
    for e in graph.edges(near: center.lat, lon: center.lon, radius: radius) {
        let i = Int(e); let L = graph.edgeLen[i]
        if graph.isSidewalk(i) { sidewalkM += L; sidewalkN += 1; if graph.isSynthetic(i) { syntheticM += L } }
        else if graph.isStreetCentreline(i) { streetM += L; streetN += 1 }
    }
    // Two sidewalks serve one street, so compare sidewalk metres against twice the bare
    // centreline metres: the share of kerb-metres that actually have a sidewalk edge.
    let kerbShare = sidewalkM / max(sidewalkM + 2 * streetM, 1)
    let label = option("label") ?? String(format: "%.4f,%.4f", center.lat, center.lon)
    print(String(format: "%-32@ sidewalk %6.1f km (%d edges, %.0f%% synthesised) · bare street %5.1f km (%d edges) · kerbs with a sidewalk edge: %3.0f%%",
                 label as NSString, sidewalkM / 1000, sidewalkN, 100 * syntheticM / max(sidewalkM, 1),
                 streetM / 1000, streetN, 100 * kerbShare))

case "blocks":
    // Sun by block (the zoomed-out field): samples the longest edges per cell of a metro
    // tile and scores them. Measures cost, and the seam error of scoring a tile from its
    // own buildings only (what the apps do zoomed out) against the stitched neighbourhood.
    //   suntool blocks --metro ../Server/nyc --center LAT,LON --at ISO [--level 2] --out blocks.geojson
    let center = coordinate(option("center"), "center")
    let level = Int(option("level") ?? "2") ?? 2
    let iso = ISO8601DateFormatter()
    guard let at = iso.date(from: option("at") ?? "") else { fail("--at needs an ISO 8601 UTC time") }
    let key = SunLattice.key(.blocks(level: level), lat: center.lat, lon: center.lon)
    let cell = SunLattice.cellSize(level: level)
    let sun = Solar.position(latitude: key.box.centerLat, longitude: key.box.centerLon, date: at)
    func blocks(_ g: PedestrianGraph, _ b: BuildingStore) -> ([SunCell], Int, Double) {
        let t0 = CFAbsoluteTimeGetCurrent()
        let ids = g.edges(in: key.box)
        let picked = SunSampler.sample(graph: g, edges: ids, cellLat: cell.lat, cellLon: cell.lon)
        var scorer = SunScorer(buildings: b)
        let scores = scorer.score(graph: g, edges: picked.edges, sun: sun)
        let cells = SunSampler.cells(graph: g, sampled: picked.edges, cellKeys: picked.cells, scores: scores,
                                     cellLat: cell.lat, cellLon: cell.lon)
        return (cells, picked.edges.count, (CFAbsoluteTimeGetCurrent() - t0) * 1000)
    }
    // Stitched (buildings of the neighbourhood cast into this tile): the city as loaded.
    let (stitched, nStitched, msStitched) = blocks(graph, city.buildings)
    print(String(format: "tile %@ · level %d (%.0f m cells) · stitched: %d cells from %d sampled edges in %.1f ms",
                 key.description, level, SunLattice.cellMetres(level: level, atLatitude: center.lat),
                 stitched.count, nStitched, msStitched))
    var features = stitched.map { c -> Feature in
        Feature(coords: [(c.box.minLat, c.box.minLon), (c.box.minLat, c.box.maxLon), (c.box.maxLat, c.box.maxLon),
                         (c.box.maxLat, c.box.minLon), (c.box.minLat, c.box.minLon)],
                properties: ["sun": Double(c.sun), "sampled": c.sampled, "metres": c.metres, "mode": "stitched"])
    }
    if let dir = option("metro") {
        // Alone: the one tile's file, its own buildings only — the zoomed-out path.
        let base = URL(fileURLWithPath: dir)
        let index = try MetroIndex.load(from: base.appendingPathComponent("metro.json"))
        guard let t = index.tiles.first(where: { $0.i == key.i && $0.j == key.j }) else { fail("no tile \(key.i),\(key.j)") }
        let t0 = CFAbsoluteTimeGetCurrent()
        let raw = try RawBundle(contentsOf: base.appendingPathComponent(t.file))
        let far = index.far.map { try? RawBundle(contentsOf: base.appendingPathComponent($0.file)).terrain } ?? nil
        let alone = try TileStitcher.stitch([raw], farTerrain: far)
        let msLoad = (CFAbsoluteTimeGetCurrent() - t0) * 1000
        let (cells, n, ms) = blocks(alone.graph, alone.buildings)
        var byBox: [String: SunCell] = [:]
        for c in stitched { byBox[String(format: "%.6f,%.6f", c.box.minLat, c.box.minLon)] = c }
        var diffs: [Double] = [], border: [Double] = []
        for c in cells {
            guard let s = byBox[String(format: "%.6f,%.6f", c.box.minLat, c.box.minLon)] else { continue }
            let d = abs(Double(c.sun - s.sun))
            diffs.append(d)
            let edgeDist = min(c.box.minLat - key.box.minLat, key.box.maxLat - c.box.maxLat,
                               (c.box.minLon - key.box.minLon) * 0.8, (key.box.maxLon - c.box.maxLon) * 0.8) * 111_320
            if edgeDist < 300 { border.append(d) }
        }
        let mean = diffs.reduce(0, +) / Double(max(diffs.count, 1))
        let bucketFlips = zip(cells, cells.compactMap { byBox[String(format: "%.6f,%.6f", $0.box.minLat, $0.box.minLon)] })
            .filter { SunBucket(fraction: $0.0.sun) != SunBucket(fraction: $0.1.sun) }.count
        print(String(format: "alone (own buildings): load+stitch %.0f ms · %d cells from %d edges in %.1f ms · vs stitched: mean |Δsun| %.3f, max %.2f, within 300 m of the border %.3f (%d cells), bucket flips %d of %d",
                     msLoad, cells.count, n, ms, mean, diffs.max() ?? 0,
                     border.reduce(0, +) / Double(max(border.count, 1)), border.count, bucketFlips, diffs.count))
        features += cells.map { c in
            Feature(coords: [(c.box.minLat, c.box.minLon), (c.box.minLat, c.box.maxLon), (c.box.maxLat, c.box.maxLon),
                             (c.box.maxLat, c.box.minLon), (c.box.minLat, c.box.minLon)],
                    properties: ["sun": Double(c.sun), "sampled": c.sampled, "metres": c.metres, "mode": "alone"])
        }
    }
    writeGeoJSON(features, meta: ["tile": key.description, "level": level, "at": iso.string(from: at)], to: out)

default:
    fail("usage: suntool sun|sunbias|blocks|coverage|sky [options]")
}

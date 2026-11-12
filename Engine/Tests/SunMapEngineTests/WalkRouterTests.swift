import XCTest
@testable import SunMapEngine

final class WalkRouterTests: XCTestCase {
    private func graph(privateShortcut: Bool = false) -> PedestrianGraph {
        PedestrianGraph(
            nodeLat: [37.78, 37.7801, 37.7802, 37.7801, 37.7801],
            nodeLon: [-122.41, -122.41, -122.41, -122.4101, -122.4102],
            edgeA: [0, 1, 0, 3, 0, 4], edgeB: [1, 2, 3, 2, 4, 2],
            edgeLen: [100, 100, 120, 120, 160, 160],
            edgeFlags: [privateShortcut ? EdgeFlag.privateAccess : 0, 0, 0, 0, 0, 0],
            bbox: BBox(minLat: 37.77, minLon: -122.42, maxLat: 37.79, maxLon: -122.40))
    }

    func testThreeTradeoffsAndLengthWeightedSun() throws {
        let routes = try WalkRouter(graph: graph()).routes(from: 0, to: 2) {
            [0.0, 0.2, 0.6, 0.6, 1.0, 1.0][Int($0)]
        }
        XCTAssertEqual(routes.map(\.kind), WalkKind.allCases)
        XCTAssertEqual(routes.map(\.metres), [200, 240, 320])
        for (route, expected) in zip(routes, [0.1, 0.6, 1.0]) {
            XCTAssertEqual(route.sunFraction, expected, accuracy: 0.001)
            XCTAssertEqual(route.nodes.first, 0)
            XCTAssertEqual(route.nodes.last, 2)
            XCTAssertEqual(Set(route.nodes).count, route.nodes.count)
        }
    }

    func testNightAndOnlyOnePathDoNotInventAlternatives() throws {
        let routes = try WalkRouter(graph: graph()).routes(from: 0, to: 2) { _ in 0 }
        XCTAssertEqual(routes.map(\.kind), [.fastest, .sunniest])
        XCTAssertEqual(routes.map(\.edges), [[0, 1], [0, 1]])
        XCTAssertTrue(routes.allSatisfy { $0.sunFraction == 0 })
    }

    func testPrivateRoadsAndInvalidEndpoints() throws {
        let router = WalkRouter(graph: graph(privateShortcut: true))
        let routes = try router.routes(from: 0, to: 2) { _ in 1 }
        XCTAssertTrue(routes.allSatisfy { !$0.edges.contains(0) })
        XCTAssertThrowsError(try router.routes(from: 0, to: 0) { _ in 1 })
        XCTAssertThrowsError(try router.routes(from: -1, to: 2) { _ in 1 })
        XCTAssertThrowsError(try router.snap(latitude: 0, longitude: 0))
        let disconnected = PedestrianGraph(nodeLat: [0, 0.001], nodeLon: [0, 0],
                                          edgeA: [], edgeB: [], edgeLen: [],
                                          bbox: BBox(minLat: 0, minLon: 0, maxLat: 1, maxLon: 1))
        XCTAssertThrowsError(try WalkRouter(graph: disconnected).routes(from: 0, to: 1) { _ in 1 })
    }

    func testBalancedRequiresVisibleTimeAndSunBenefitsAndRejectsDominatedPaths() {
        func route(_ metres: Double, _ sun: Double) -> WalkRoute {
            WalkRoute(kind: .fastest, nodes: [], edges: [], metres: metres, sunFraction: sun)
        }
        let fastest = route(840, 0.20), sunniest = route(1260, 0.80)
        let noMiddle = WalkRouter.choices(fastest: fastest, candidates: [
            fastest, sunniest, route(1259, 0.60), route(900, 0.204)
        ])
        XCTAssertEqual(noMiddle.map(\.kind), [.fastest, .sunniest])
        let result = WalkRouter.choices(fastest: fastest, candidates: [
            fastest, sunniest, route(1008, 0.55), route(1092, 0.50), route(924, 0.30)
        ])
        XCTAssertEqual(result.map(\.kind), WalkKind.allCases)
        XCTAssertEqual(result[1].metres, 1008)
        XCTAssertLessThan(result[1].minutes, result[2].minutes)
        XCTAssertGreaterThan(result[1].sunPercent, result[0].sunPercent)
    }
}

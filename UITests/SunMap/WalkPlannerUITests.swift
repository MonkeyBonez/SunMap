import XCTest

final class WalkPlannerUITests: XCTestCase {
    private func pick(_ app: XCUIApplication, endpoint: String, query: String) {
        let input = app.textFields["\(endpoint)Input"]
        XCTAssertTrue(input.waitForExistence(timeout: 10))
        input.tap()
        let clear = app.buttons[endpoint == "walkStart" ? "clearStartInput" : "clearEndInput"]
        if clear.exists { clear.tap() }
        input.typeText(query)
        app.buttons["searchPlaces"].tap()
        let result = app.buttons.matching(identifier: "placeResult").firstMatch
        XCTAssertTrue(result.waitForExistence(timeout: 30), app.debugDescription)
        result.tap()
    }

    func testDefaultTimeAndThreeSelectableWalks() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestCenter", "37.78415,-122.40060"]
        app.launch()
        XCTAssertTrue(app.staticTexts["sunTime"].waitForExistence(timeout: 30))
        XCTAssertTrue(app.staticTexts["sunTime"].label.contains("1:00"), app.staticTexts["sunTime"].label)
        XCTAssertFalse(app.segmentedControls["skyPicker"].exists)
        XCTAssertTrue(app.sliders["timeScrubber"].waitForExistence(timeout: 60))
        pick(app, endpoint: "walkStart", query: "37.78415,-122.40060")
        pick(app, endpoint: "walkEnd", query: "37.7936,-122.3958")
        XCTAssertTrue(app.buttons["routeFastest"].waitForExistence(timeout: 120), app.debugDescription)
        XCTAssertLessThan(app.textFields["walkEndInput"].frame.maxY, app.buttons["routeFastest"].frame.minY)
        XCTAssertEqual(app.buttons["routeFastest"].frame.midY, app.buttons["routeSunniest"].frame.midY, accuracy: 3)
        let kinds = ["Fastest", "Balanced", "Sunniest"].filter { app.buttons["route\($0)"].exists }
        XCTAssertTrue(kinds.contains("Sunniest"))
        for kind in kinds {
            let card = app.buttons["route\(kind)"]
            XCTAssertTrue(card.label.contains("minutes"), card.label)
            XCTAssertTrue(card.label.contains("percent sunlight"), card.label)
            card.tap()
            XCTAssertTrue(card.isSelected, app.debugDescription)
            XCTAssertEqual(app.otherElements["sunMap"].value as? String, "\(kinds.count) route previews, selected \(kind)")
        }
        let timeBefore = app.staticTexts["sunTime"].label
        app.buttons["stepForward"].tap()
        XCTAssertNotEqual(app.staticTexts["sunTime"].label, timeBefore)
        XCTAssertTrue(app.buttons["routeSunniest"].waitForExistence(timeout: 120))
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "sf-three-walk-options"
        shot.lifetime = .keepAlways
        add(shot)
        print("WALK ACCESSIBILITY TREE\n\(app.debugDescription)")
    }

    func testNightAndUnsupportedEndpoint() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestCenter", "37.78415,-122.40060",
                               "-uiTestDate", "2026-11-12T08:00:00Z"]
        app.launch()
        XCTAssertTrue(app.textFields["walkStartInput"].waitForExistence(timeout: 30))
        pick(app, endpoint: "walkStart", query: "37.78415,-122.40060")
        pick(app, endpoint: "walkEnd", query: "37.7936,-122.3958")
        XCTAssertTrue(app.buttons["routeFastest"].waitForExistence(timeout: 120))
        XCTAssertFalse(app.buttons["routeBalanced"].exists)
        for kind in ["Fastest", "Sunniest"] {
            XCTAssertTrue(app.buttons["route\(kind)"].label.contains("0 percent sunlight"))
        }
        pick(app, endpoint: "walkEnd", query: "0,0")
        XCTAssertTrue(app.staticTexts["walkError"].waitForExistence(timeout: 30))
        XCTAssertFalse(app.buttons["routeFastest"].exists)
    }

    func testSearchSanFranciscoLandmark() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestCenter", "37.78415,-122.40060"]
        app.launch()
        XCTAssertTrue(app.textFields["walkEndInput"].waitForExistence(timeout: 30))
        pick(app, endpoint: "walkEnd", query: "Ferry Building San Francisco")
        XCTAssertTrue((app.textFields["walkEndInput"].value as? String)?.contains("Ferry") == true, app.debugDescription)
    }

    func testNamedAddressesAndAutocomplete() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestCenter", "37.78415,-122.40060"]
        app.launch()
        pick(app, endpoint: "walkStart", query: "340 Fremont St San Francisco")
        XCTAssertTrue((app.textFields["walkStartInput"].value as? String)?.contains("340") == true)
        pick(app, endpoint: "walkEnd", query: "LinkedIn 222 2nd St San Francisco")
        XCTAssertTrue(app.buttons["routeFastest"].waitForExistence(timeout: 120), app.debugDescription)
        let destination = app.textFields["walkEndInput"]
        destination.tap()
        app.buttons["clearEndInput"].tap()
        destination.typeText("Chase Center")
        let suggestion = app.buttons.matching(identifier: "placeSuggestion").firstMatch
        XCTAssertTrue(suggestion.waitForExistence(timeout: 30), app.debugDescription)
        suggestion.tap()
        XCTAssertTrue(app.buttons["routeFastest"].waitForExistence(timeout: 120), app.debugDescription)
        XCTAssertTrue((destination.value as? String)?.contains("Chase") == true)
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "sf-top-address-inputs"
        shot.lifetime = .keepAlways
        add(shot)
    }
}

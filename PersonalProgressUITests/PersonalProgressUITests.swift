import XCTest

final class PersonalProgressUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    func testOnboardingFlowCompletesSuccessfully() throws {
        // Welcome screen
        let getStartedButton = app.buttons["Get Started"]
        XCTAssertTrue(getStartedButton.waitForExistence(timeout: 3))
        getStartedButton.tap()

        // Letter screen
        let textEditor = app.textViews.firstMatch
        XCTAssertTrue(textEditor.waitForExistence(timeout: 3))
        textEditor.tap()
        textEditor.typeText("This is my 2026 annual letter.")

        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.isEnabled)
        continueButton.tap()

        // Domains screen
        let firstDomain = app.staticTexts.element(boundBy: 0)
        XCTAssertTrue(firstDomain.waitForExistence(timeout: 3))

        // Tap first domain to select
        app.cells.firstMatch.tap()

        let openMyYearButton = app.buttons["Open My Year"]
        XCTAssertTrue(openMyYearButton.isEnabled)
        openMyYearButton.tap()

        // Should now see main tab bar
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 3))
    }

    func testContinueButtonDisabledWithEmptyLetter() throws {
        app.buttons["Get Started"].tap()

        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 3))
        XCTAssertFalse(continueButton.isEnabled)
    }

    func testOpenMyYearDisabledWithNoDomains() throws {
        app.buttons["Get Started"].tap()

        let textEditor = app.textViews.firstMatch
        textEditor.tap()
        textEditor.typeText("Letter content")
        app.buttons["Continue"].tap()

        let openMyYearButton = app.buttons["Open My Year"]
        XCTAssertTrue(openMyYearButton.waitForExistence(timeout: 3))
        XCTAssertFalse(openMyYearButton.isEnabled)
    }
}

import XCTest

final class PersonalProgressUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        return app
    }

    @MainActor
    func testOnboardingFlowCompletesSuccessfully() throws {
        let app = launchApp()

        // Step 0: Welcome
        let beginButton = app.buttons["Begin"]
        XCTAssertTrue(beginButton.waitForExistence(timeout: 3))
        beginButton.tap()

        // Step 1: Philosophy
        let imReadyButton = app.buttons["I'm ready"]
        XCTAssertTrue(imReadyButton.waitForExistence(timeout: 3))
        imReadyButton.tap()

        // Step 2: Annual Vision — type a letter then advance
        let textEditor = app.textViews.firstMatch
        XCTAssertTrue(textEditor.waitForExistence(timeout: 3))
        textEditor.tap()
        textEditor.typeText("This is my 2026 annual letter.")

        let setMyDomainsButton = app.buttons["Set My Domains"]
        XCTAssertTrue(setMyDomainsButton.waitForExistence(timeout: 3))
        XCTAssertTrue(setMyDomainsButton.isEnabled)
        setMyDomainsButton.tap()

        // Step 3: Domains — select one domain
        XCTAssertTrue(app.cells.firstMatch.waitForExistence(timeout: 3))
        app.cells.firstMatch.tap()

        let defineSuccessButton = app.buttons["Define Success"]
        XCTAssertTrue(defineSuccessButton.isEnabled)
        defineSuccessButton.tap()

        // Step 4: Success Definitions — fill in at least one definition
        let definitionField = app.textFields.firstMatch
        XCTAssertTrue(definitionField.waitForExistence(timeout: 3))
        definitionField.tap()
        definitionField.typeText("I will be consistent.")

        let setCheckInDatesButton = app.buttons["Set Check-In Dates"]
        XCTAssertTrue(setCheckInDatesButton.waitForExistence(timeout: 3))
        XCTAssertTrue(setCheckInDatesButton.isEnabled)
        setCheckInDatesButton.tap()

        // Step 5: Quarterly Dates — already pre-filled, just advance
        let almostDoneButton = app.buttons["Almost Done"]
        XCTAssertTrue(almostDoneButton.waitForExistence(timeout: 3))
        almostDoneButton.tap()

        // Step 6: Confirmation
        let openMyYearButton = app.buttons["Open My Year"]
        XCTAssertTrue(openMyYearButton.waitForExistence(timeout: 3))
        openMyYearButton.tap()

        // Should now see main tab bar
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
    }

    @MainActor
    func testSetMyDomainsDisabledWithEmptyLetter() throws {
        let app = launchApp()

        app.buttons["Begin"].tap()
        app.buttons["I'm ready"].waitForExistence(timeout: 3)
        app.buttons["I'm ready"].tap()

        let setMyDomainsButton = app.buttons["Set My Domains"]
        XCTAssertTrue(setMyDomainsButton.waitForExistence(timeout: 3))
        XCTAssertFalse(setMyDomainsButton.isEnabled)
    }

    @MainActor
    func testDefineSuccessDisabledWithNoDomains() throws {
        let app = launchApp()

        app.buttons["Begin"].tap()
        app.buttons["I'm ready"].waitForExistence(timeout: 3)
        app.buttons["I'm ready"].tap()

        let textEditor = app.textViews.firstMatch
        XCTAssertTrue(textEditor.waitForExistence(timeout: 3))
        textEditor.tap()
        textEditor.typeText("Letter content")

        app.buttons["Set My Domains"].tap()

        let defineSuccessButton = app.buttons["Define Success"]
        XCTAssertTrue(defineSuccessButton.waitForExistence(timeout: 3))
        XCTAssertFalse(defineSuccessButton.isEnabled)
    }
}

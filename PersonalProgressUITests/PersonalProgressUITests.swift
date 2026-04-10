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

    // MARK: - Helpers

    /// Taps the annual letter TextEditor and waits for the keyboard before typing.
    @MainActor
    private func typeIntoAnnualLetter(_ text: String, app: XCUIApplication) {
        let textEditor = app.textViews["onboarding.annualLetter"]
        XCTAssertTrue(textEditor.waitForExistence(timeout: 5))
        textEditor.tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 3))
        textEditor.typeText(text)
    }

    // MARK: - Tests

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

        // Step 2: Annual Vision
        typeIntoAnnualLetter("This is my 2026 annual letter.", app: app)

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
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 3))
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
        XCTAssertTrue(app.buttons["I'm ready"].waitForExistence(timeout: 3))
        app.buttons["I'm ready"].tap()

        let setMyDomainsButton = app.buttons["Set My Domains"]
        XCTAssertTrue(setMyDomainsButton.waitForExistence(timeout: 3))
        XCTAssertFalse(setMyDomainsButton.isEnabled)
    }

    @MainActor
    func testDefineSuccessDisabledWithNoDomains() throws {
        let app = launchApp()

        app.buttons["Begin"].tap()
        XCTAssertTrue(app.buttons["I'm ready"].waitForExistence(timeout: 3))
        app.buttons["I'm ready"].tap()

        typeIntoAnnualLetter("Letter content", app: app)

        let setMyDomainsButton = app.buttons["Set My Domains"]
        XCTAssertTrue(setMyDomainsButton.waitForExistence(timeout: 3))
        setMyDomainsButton.tap()

        let defineSuccessButton = app.buttons["Define Success"]
        XCTAssertTrue(defineSuccessButton.waitForExistence(timeout: 3))
        XCTAssertFalse(defineSuccessButton.isEnabled)
    }
}

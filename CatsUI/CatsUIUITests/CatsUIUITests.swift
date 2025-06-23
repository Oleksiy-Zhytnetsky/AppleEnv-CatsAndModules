//
//  CatsUIUITests.swift
//  CatsUIUITests
//
//  Created by Oleksiy Zhytnetsky on 23.06.2025.
//

import XCTest

final class CatsUIUITests: XCTestCase {
    
    @MainActor
    func testTakeScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        let consentAlert = app.alerts["Crash Reporting"]
        if consentAlert.waitForExistence(timeout: 5) {
            consentAlert.buttons["Allow"].tap()
        }
        snapshot("OleksiyZhytnetskyi_MainScreen")
        
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
        
        let allTextElements = scrollView.descendants(matching: .staticText)
        XCTAssertFalse(allTextElements.allElementsBoundByIndex.isEmpty)
        
        let firstCell = allTextElements.element(boundBy: 0)
        XCTAssertTrue(firstCell.isHittable)
        firstCell.tap()
        snapshot("OleksiyZhytnetskyi_DetailsScreen")
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}

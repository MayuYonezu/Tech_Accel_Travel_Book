//
//  Tech_Accel_Travel_BookUITests.swift
//  Tech_Accel_Travel_BookUITests
//
//  Created by 田野 辺開 on 1/21/23.
//

import XCTest

final class TechAccelTravelBookUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

//
//  RSSNewsTests.swift
//  RSSNewsTests
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import XCTest
@testable import RSSNews

class DateTimeManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Tests convertation of UTC format date to Date object
    func testConvertUTCStringToDateFormat() {

        let date = DateTimeManager.convertUTCStringToDateFormat(from: "2019-03-05T05:47:55Z")

        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!

        let components = calendar.dateComponents([Calendar.Component.year,
                                                  Calendar.Component.month,
                                                  Calendar.Component.day,
                                                  Calendar.Component.hour,
                                                  Calendar.Component.minute,
                                                  Calendar.Component.second],
                                                 from: date!)

        /// Success test
        XCTAssertEqual(components.year!, 2019)
        XCTAssertEqual(components.month!, 3)
        XCTAssertEqual(components.day!, 5)
        XCTAssertEqual(components.hour!, 5)
        XCTAssertEqual(components.minute!, 47)
        XCTAssertEqual(components.second!, 55)

        /// Unmatched format test
        XCTAssertNil(DateTimeManager.convertUTCStringToDateFormat(from: "2019-03-05T05:47:55"))
        XCTAssertNil(DateTimeManager.convertUTCStringToDateFormat(from: "2019-03-0505:47:55Z"))
    }

    /// Tests getting time interval between two date objects with day precision
    func testIntervalBetweenDatesWithDayPrecision() {

        let date1 = Date()
        /// 1 day, 2 hours, 35 minutes, 49 seconds earlier
        let date2 = date1 - 86400.0 - 7200.0 - 2100.0 - 49.0

        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!

        let dateInterval = DateTimeManager.intervalBetweenDatesWithDayPrecision(calendar: calendar, from: date2, to: date1)

        XCTAssertEqual(dateInterval.day!, 1)
        XCTAssertEqual(dateInterval.hour!, 2)
        XCTAssertEqual(dateInterval.minute!, 35)
        XCTAssertEqual(dateInterval.second!, 49)
    }

    /// Tests getting time in text format elapsed from date to current time
    func testElapsedTime() {

        let date = Date()

        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 1), "1 second ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 29), "29 seconds ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 60), "1 minute ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 600), "10 minutes ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 3600), "one hour ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 7200), "two hours ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 10800), "three hours ago")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: date - 1), "1 second ago")

        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!

        var pastDate = DateTimeManager.convertUTCStringToDateFormat(from: "2019-03-05T05:47:55Z")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: pastDate, calendar: calendar), "today at 05:47")

        pastDate = DateTimeManager.convertUTCStringToDateFormat(from: "2019-03-04T05:47:55Z")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: pastDate, calendar: calendar), "yesterday at 05:47")

        pastDate = DateTimeManager.convertUTCStringToDateFormat(from: "2019-02-05T05:47:55Z")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: pastDate, calendar: calendar), "05 Feb at 05:47")

        pastDate = DateTimeManager.convertUTCStringToDateFormat(from: "2018-02-05T05:47:55Z")
        XCTAssertEqual(DateTimeManager.elapsedTime(from: pastDate, calendar: calendar), "05 Feb 2018")

    }
}

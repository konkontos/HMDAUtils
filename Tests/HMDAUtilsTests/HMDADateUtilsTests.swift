//
//  HMDADateUtilsTests.swift
//  HMDAUtilsTests
//
//  Created by Konstantinos Kontos on 17/10/20.
//

import XCTest
@testable import HMDAUtils

final class HMDADateUtilsTests: XCTestCase {
    let dateA = Date().regionalDate()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsInFuture() throws {
        let dateB = dateA.advanced(by: .day, value: 1)
        XCTAssert(dateB.isInFuture() == true)
    }
    
    func testIsNotInFuture() throws {
        let dateB = dateA.advanced(by: .day, value: -1)
        XCTAssert(dateB.isInFuture() == false)
    }
    
    func testIsInPast() throws {
        let dateB = dateA.advanced(by: .day, value: -1)
        XCTAssert(dateB.isInPast() == true)
    }
    
    func testIsNotInPast() throws {
        let dateB = dateA.advanced(by: .day, value: 1)
        XCTAssert(dateB.isInPast() == false)
    }

    func testDiffCalc() throws {
        let dateB = dateA.advanced(by: .weekOfMonth, value: 1)
        XCTAssert(dateA.difference(to: dateB, granularity: .hour) == 168)
    }
    
    func testIsInSameWeek() throws {
        let dateB = dateA.advanced(by: .day, value: 6)
        XCTAssert(dateA.difference(to: dateB, granularity: .weekOfMonth) == 0)
    }
    
    func testIsInSameMonth() throws {
        let dateB = dateA.advanced(by: .day, value: 20)
        XCTAssert(dateA.difference(to: dateB, granularity: .month) == 0)
    }
    
    func testIsInSameYear() throws {
        let dateB = dateA.advanced(by: .day, value: 220)
        XCTAssert(dateA.difference(to: dateB, granularity: .year) == 0)
    }
    
    func testIsNotInSameYear() throws {
        let dateB = dateA.advanced(by: .day, value: 400)
        XCTAssert(dateA.difference(to: dateB, granularity: .year) > 0)
    }
    
    func testIsInToday() throws {
        let dateB = dateA.advanced(by: .hour, value: 1)
        XCTAssert(dateA.isInToday(with: dateB))
    }
    
    func testIsInTomorrow() throws {
        let dateB = dateA.advanced(by: .hour, value: 28)
        XCTAssert(dateA.isInTomorrow(with: dateB))
    }
    
    func testIsWeekend() throws {
        let components = DateComponents(calendar: Calendar.autoupdatingCurrent,
                       timeZone: TimeZone.current,
                       year: 2020,
                       month: 10,
                       day: 17,
                       hour: 12,
                       minute: 0,
                       second: 0
                       )
        
        let dateB = DateInRegion.regionalDate(from: components)
        
        XCTAssert(dateB.isWeekend)
    }
    
    
/*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
*/

}


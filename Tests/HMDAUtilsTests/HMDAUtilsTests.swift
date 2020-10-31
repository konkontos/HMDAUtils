import XCTest
@testable import HMDAUtils

final class HMDAUtilsTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testArrayDuplicates() {
        let duplicatesArr = ["John Doe", "John Smith"]
//        let duplicatesArr = ["John Doe", "John Doe"]
        XCTAssert(duplicatesArr.containsDuplicates == false)
    }
    
/*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HMDAUtils().text, "Hello, World!")
    }
*/

/*
    static var allTests = [
        ("testExample", testExample),
    ]
*/
    
}




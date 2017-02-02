import XCTest
@testable import skelletor

class skelletorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(skelletor().text, "Hello, World!")
    }


    static var allTests : [(String, (skelletorTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

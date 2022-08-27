import XCTest
@testable import WhatWeEat

class JSONParserTests: XCTestCase {
    func test_Menu타입_정상적으로_decode되는지_테스트() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MockRandomMenu", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path) else {
            XCTFail()
            return
        }
        
        let data = jsonString.data(using: .utf8)
        guard let result = JSONParser<Menu>().decode(from: data) else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.name, "장어구이")
        XCTAssertEqual(
            result.imageURL,
            "https://user-images.githubusercontent.com/70856586/176447390-738d8b83-417c-4f5f-98bb-af3dd37b8813.jpg"
        )
    }
}

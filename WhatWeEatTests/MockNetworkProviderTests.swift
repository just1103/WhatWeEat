import XCTest
import RxSwift
@testable import WhatWeEat

class MockNetworkProviderTests: XCTestCase {
    let mockSession: URLSessionProtocol! = MockURLSession()
    var sut: NetworkProvider!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkProvider(session: mockSession)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }
    
    func test_fetchData가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "MockSession fetchData 비동기 테스트")
        
        let observable = sut.fetchData(
            api: WhatWeEatURL.RandomMenuAPI(),
            decodingType: Menu.self
        )
        _ = observable.subscribe(onNext: { randomMenu in
            XCTAssertNotNil(randomMenu)
            XCTAssertEqual(randomMenu.name, "장어구이")
            XCTAssertEqual(
                randomMenu.imageURL,
                "https://user-images.githubusercontent.com/70856586/176447390-738d8b83-417c-4f5f-98bb-af3dd37b8813.jpg"
            )
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
}

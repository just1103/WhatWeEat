import XCTest
import RxSwift
@testable import WhatWeEat

class NetworkProviderTests: XCTestCase {
    var sut: NetworkProvider!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkProvider()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }
    
    func test_RandomMenuAPI가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "RandomMenuAPI 비동기 테스트")
        
        let observable = sut.fetchData(
            api: WhatWeEatURL.RandomMenuAPI(),
            decodingType: Menu.self
        )
        _ = observable.subscribe(onNext: { randomMenu in
            XCTAssertNotNil(randomMenu)
            XCTAssertNotEqual(randomMenu.name, "")
            XCTAssertNotNil(randomMenu.imageURL)
            
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
}

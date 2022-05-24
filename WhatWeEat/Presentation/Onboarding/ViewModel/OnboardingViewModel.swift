import Foundation
import RxSwift

final class OnboardingViewModel {
    // MARK: - Nested Types
    struct Input {
        let currentIndexForPreviousPage: Observable<Int>
        let currentIndexForNextPageAndPageCount: Observable<(Int, Int)>
    }
    
    struct Output {
        let previousPageIndex: Observable<Int?>
        let nextPageIndex: Observable<Int?>
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let previousPageIndex = configurePreviousPageIndexObservable(by: input.currentIndexForPreviousPage)
        let nextPageIndex = configureNextPageIndexObservable(by: input.currentIndexForNextPageAndPageCount)
        let output = Output(previousPageIndex: previousPageIndex, nextPageIndex: nextPageIndex)
        
        return output
    }
    
    private func configurePreviousPageIndexObservable(by inputObserver: Observable<Int>) -> Observable<Int?> {
        inputObserver
            .flatMap { currentIndex -> Observable<Int?> in
                if currentIndex == 0 {
                    return Observable.just(nil)
                } else {
                    return Observable.just(currentIndex - 1)
                }
            }
    }
    
    private func configureNextPageIndexObservable(by inputObserver: Observable<(Int, Int)>) -> Observable<Int?> {
        inputObserver
            .flatMap { (currentIndex, pageCount) -> Observable<Int?> in
                if currentIndex < pageCount - 1 {
                    return Observable.just(currentIndex + 1)
                } else {
                    return Observable.just(nil)
                }
            }
    }
}

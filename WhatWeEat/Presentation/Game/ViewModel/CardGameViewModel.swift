import Foundation
import RxSwift

final class CardGameViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let likeButtonDidTap: Observable<Void>
        let hateButtonDidTap: Observable<Void>
        let skipButtonDidTap: Observable<Void>
        let previousQuestionButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let initialCardIndicies: Observable<CardIndicies>
        let nextCardIndiciesWhenLike: Observable<CardIndicies>
        let nextCardIndiciesWhenHate: Observable<CardIndicies>
        let nextCardIndiciesWhenSkip: Observable<CardIndicies>
        let previousCardIndiciesAndResult: Observable<(CardIndicies, Bool?)>
    }
    
    // MARK: - Properties
    private var visibleCardIndices = (first: 0, second: 1, third: 2)
    private var results = [Bool?]()
    private var isLastQuestion: Bool {
        return results.count >= 7
    }
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output { 
        let initialCardIndicies = configureInitialCardIndiciesObservable(with: input.invokedViewDidLoad)
        let nextCardIndiciesWhenLike = configureNextCardIndiciesWhenLikeObservable(with: input.likeButtonDidTap)
        let nextCardIndiciesWhenHate = configureNextCardIndiciesWhenHateObservable(with: input.hateButtonDidTap)
        let nextCardIndiciesWhenSkip = configureNextCardIndiciesWhenSkipObservable(with: input.skipButtonDidTap)
        let previousCardIndicies = configurePreviousCardIndiciesObservable(with: input.previousQuestionButtonDidTap)
        
        let output = Output(
            initialCardIndicies: initialCardIndicies,
            nextCardIndiciesWhenLike: nextCardIndiciesWhenLike,
            nextCardIndiciesWhenHate: nextCardIndiciesWhenHate,
            nextCardIndiciesWhenSkip: nextCardIndiciesWhenSkip,
            previousCardIndiciesAndResult: previousCardIndicies
        )
        
        return output
    }
    
    private func configureInitialCardIndiciesObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<CardIndicies> in
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenLikeObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<CardIndicies> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.results.append(true)
                
                if self.isLastQuestion {
                    // TODO: 다음화면으로 이동
                    return Observable.just(self.visibleCardIndices)
                }
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenHateObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.results.append(false)
                
                if self.isLastQuestion {
                    // TODO: 다음화면으로 이동
                    return Observable.just(self.visibleCardIndices)
                }
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenSkipObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.results.append(nil)
                
                if self.isLastQuestion {
                    // TODO: 다음화면으로 이동
                    return Observable.just(self.visibleCardIndices)
                }
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func nextVisibleCardIndices(
        from currentVisibleCardIndices: (first: Int, second: Int, third: Int)
    ) -> CardIndicies {
        var visibleCardIndices = currentVisibleCardIndices
        visibleCardIndices.first += 1
        visibleCardIndices.second += 1
        visibleCardIndices.third += 1
        
        return visibleCardIndices
    }
    
    private func configurePreviousCardIndiciesObservable(
        with inputObserver: Observable<Void>
    ) -> Observable<(CardIndicies, Bool?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies, Bool?)> in
                if self.results.isEmpty == false {
                    self.visibleCardIndices = self.previousVisibleCardIndices(from: self.visibleCardIndices)
                    let lastestAnswer = self.results.removeLast()
                    
                    return Observable.just((self.visibleCardIndices, lastestAnswer))
                } else {
                    return Observable.just((self.visibleCardIndices, nil))
                }
            }
    }
    
    private func previousVisibleCardIndices(
        from currentVisibleCardIndices: (first: Int, second: Int, third: Int)
    ) -> CardIndicies {
        var visibleCardIndices = currentVisibleCardIndices
        visibleCardIndices.first -= 1
        visibleCardIndices.second -= 1
        visibleCardIndices.third -= 1
        
        return visibleCardIndices
    }
}

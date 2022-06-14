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
        let menuNations: Observable<[MenuNation]>
        let mainIngredients: Observable<[MainIngredient]>
        let nextCardIndiciesWhenLike: Observable<CardIndicies>
        let nextCardIndiciesWhenHate: Observable<CardIndicies>
        let nextCardIndiciesWhenSkip: Observable<CardIndicies>
        let previousCardIndiciesAndResult: Observable<(CardIndicies, Bool?)>
    }
    
    // MARK: - Properties
    private weak var coordinator: GameCoordinator!
    private var visibleCardIndices = (first: 0, second: 1, third: 2)
    private var results = [Bool?]()
    private var isLastQuestion: Bool {
        return results.count >= 9
    }
    
    // MARK: - Initializers
    init(coordinator: GameCoordinator) {
        self.coordinator = coordinator
    }
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output { 
        let initialCardIndicies = configureInitialCardIndiciesObservable(with: input.invokedViewDidLoad)
        let menuNations = configureMenuNationsObservable(with: input.invokedViewDidLoad)
        let mainIngredients = configureMainIngredientsObservable(with: input.invokedViewDidLoad)
        let nextCardIndiciesWhenLike = configureNextCardIndiciesWhenLikeObservable(with: input.likeButtonDidTap)
        let nextCardIndiciesWhenHate = configureNextCardIndiciesWhenHateObservable(with: input.hateButtonDidTap)
        let nextCardIndiciesWhenSkip = configureNextCardIndiciesWhenSkipObservable(with: input.skipButtonDidTap)
        let previousCardIndicies = configurePreviousCardIndiciesObservable(with: input.previousQuestionButtonDidTap)
        
        let output = Output(
            initialCardIndicies: initialCardIndicies,
            menuNations: menuNations,
            mainIngredients: mainIngredients,
            nextCardIndiciesWhenLike: nextCardIndiciesWhenLike,
            nextCardIndiciesWhenHate: nextCardIndiciesWhenHate,
            nextCardIndiciesWhenSkip: nextCardIndiciesWhenSkip,
            previousCardIndiciesAndResult: previousCardIndicies
        )
        
        return output
    }
    
    private func configureInitialCardIndiciesObservable(with inputObserver: Observable<Void>) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<CardIndicies> in
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureMenuNationsObservable(with inputObserver: Observable<Void>) -> Observable<[MenuNation]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MenuNation]> in
                return Observable.just(self.createMenuNations())
            }
    }
    
    private func configureMainIngredientsObservable(with inputObserver: Observable<Void>) -> Observable<[MainIngredient]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MainIngredient]> in
                return Observable.just(self.createMainIngredients())
            }
    }
    
    private func createMenuNations() -> [MenuNation] {
        let korean = MenuNation(kind: .korean, descriptionText: "한식")
        let western = MenuNation(kind: .western, descriptionText: "양식")
        let japanese = MenuNation(kind: .japanese, descriptionText: "일식")
        let chinese = MenuNation(kind: .chinese, descriptionText: "중식")
        let convenient = MenuNation(kind: .convenient, descriptionText: "분식")
        let exotic = MenuNation(kind: .exotic, descriptionText: "이국음식\n(아시안)")
        let etc = MenuNation(kind: .etc, descriptionText: "기타\n(샐러드, 치킨)")
        let menuNations = [korean, western, japanese, chinese, convenient, exotic, etc]
        
        return menuNations
    }
    
    private func createMainIngredients() -> [MainIngredient] {
        let rice = MainIngredient(kind: .rice, descriptionText: "밥")
        let noodle = MainIngredient(kind: .noodle, descriptionText: "면")
        let soup = MainIngredient(kind: .soup, descriptionText: "국")
        let hateAll = MainIngredient(kind: .hateAll, descriptionText: "밥, 면, 국 다 싫어\n(치킨, 떡볶이, 딤섬)")
        let mainIngredients = [rice, noodle, soup, hateAll]
        
        return mainIngredients
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
                    self.coordinator.showMultipleChoiceGamePage(with: self.results)
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
                    self.coordinator.showMultipleChoiceGamePage(with: self.results)
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
                    self.coordinator.showMultipleChoiceGamePage(with: self.results)
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

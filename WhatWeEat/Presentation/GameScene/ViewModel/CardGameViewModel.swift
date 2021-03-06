import Foundation
import RxSwift

final class CardGameViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let yesButtonDidTap: Observable<Void>
        let noButtonDidTap: Observable<Void>
        let skipButtonDidTap: Observable<Void>
        let previousQuestionButtonDidTap: Observable<Void>
        let menuNationsCellDidSelect: Observable<IndexPath>
        let mainIngredientsCellDidSelect: Observable<IndexPath>
    }
    
    struct Output {
        let initialCardIndiciesAndPinNumber: Observable<(CardIndicies, String?)>
        let menuNations: Observable<[MenuNation]>
        let mainIngredients: Observable<[MainIngredient]>
        let nextCardIndiciesWhenLike: Observable<CardIndicies>
        let nextCardIndiciesWhenHate: Observable<CardIndicies>
        let nextCardIndiciesWhenSkip: Observable<CardIndicies>
        let previousCardIndiciesAndResult: Observable<(CardIndicies, Bool?)>
        let menuNationsSelectedindexPath: Observable<IndexPath>
        let mainIngredientsSelectedindexPath: Observable<IndexPath>
    }
    
    // MARK: - Properties
    private weak var coordinator: GameCoordinator!
    private let pinNumber: String?
    private var gameAnswers = [Bool?]()
    private var visibleCardIndices = (first: 0, second: 1, third: 2)
    private var menuNations = [MenuNation]()
    private var mainIngredients = [MainIngredient]()
    private var isLastQuestion: Bool {
        return gameAnswers.count >= 9
    }
    private let disposeBag = DisposeBag()
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Initializers
    init(coordinator: GameCoordinator, pinNumber: String?) {
        self.coordinator = coordinator
        self.pinNumber = pinNumber
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let initialCardIndiciesAndPinNumber = configureInitialCardIndiciesAndPinNumber(by: input.invokedViewDidLoad)
        let menuNations = configureMenuNations(by: input.invokedViewDidLoad)
        let mainIngredients = configureMainIngredients(by: input.invokedViewDidLoad)
        let nextCardIndiciesWhenLike = configureNextCardIndiciesWhenLike(by: input.yesButtonDidTap)
        let nextCardIndiciesWhenHate = configureNextCardIndiciesWhenHate(by: input.noButtonDidTap)
        let nextCardIndiciesWhenSkip = configureNextCardIndiciesWhenSkip(by: input.skipButtonDidTap)
        let previousCardIndicies = configurePreviousCardIndicies(by: input.previousQuestionButtonDidTap)
        let menuNationsSelectedindexPath = configureMenuNationsSelectedindexPath(
            by: input.menuNationsCellDidSelect
        )
        let mainIngredientsSelectedindexPath = configureMainIngredientsSelectedindexPath(
            by: input.mainIngredientsCellDidSelect
        )
        
        let output = Output(
            initialCardIndiciesAndPinNumber: initialCardIndiciesAndPinNumber,
            menuNations: menuNations,
            mainIngredients: mainIngredients,
            nextCardIndiciesWhenLike: nextCardIndiciesWhenLike,
            nextCardIndiciesWhenHate: nextCardIndiciesWhenHate,
            nextCardIndiciesWhenSkip: nextCardIndiciesWhenSkip,
            previousCardIndiciesAndResult: previousCardIndicies,
            menuNationsSelectedindexPath: menuNationsSelectedindexPath,
            mainIngredientsSelectedindexPath: mainIngredientsSelectedindexPath
        )
        
        return output
    }
    
    private func configureInitialCardIndiciesAndPinNumber(
        by inputObserver: Observable<Void>
    ) -> Observable<(CardIndicies, String?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies, String?)> in
                return Observable.just((self.visibleCardIndices, self.pinNumber))
            }
    }
    
    private func configureMenuNations(by inputObserver: Observable<Void>) -> Observable<[MenuNation]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MenuNation]> in
                return Observable.just(self.createMenuNations())
            }
    }
    
    private func configureMainIngredients(by inputObserver: Observable<Void>) -> Observable<[MainIngredient]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MainIngredient]> in
                return Observable.just(self.createMainIngredients())
            }
    }
    
    private func createMenuNations() -> [MenuNation] {
        let korean = MenuNation(kind: .korean, descriptionText: Text.koreanDescriptionText)
        let western = MenuNation(kind: .western, descriptionText: Text.westernDescriptionText)
        let japanese = MenuNation(kind: .japanese, descriptionText: Text.japaneseDescriptionText)
        let chinese = MenuNation(kind: .chinese, descriptionText: Text.chineseDescriptionText)
        let convenient = MenuNation(kind: .convenient, descriptionText: Text.convenientDescriptionText)
        let exotic = MenuNation(kind: .exotic, descriptionText: Text.exoticDescriptionText)
        let etc = MenuNation(kind: .etc, descriptionText: Text.etcDescriptionText)
        menuNations = [korean, western, japanese, chinese, convenient, exotic, etc]
        
        return menuNations
    }
    
    private func createMainIngredients() -> [MainIngredient] {
        let rice = MainIngredient(kind: .rice, descriptionText: Text.riceDescriptionText)
        let noodle = MainIngredient(kind: .noodle, descriptionText: Text.noodleDescriptionText)
        let soup = MainIngredient(kind: .soup, descriptionText: Text.soupDescriptionText)
        let hateAll = MainIngredient(kind: .hateAll, descriptionText: Text.hateAllDescriptionText)
        mainIngredients = [rice, noodle, soup, hateAll]
        
        return mainIngredients
    }
    
    private func configureNextCardIndiciesWhenLike(
        by inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<CardIndicies> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameAnswers.append(true)
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenHate(
        by inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameAnswers.append(false)
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenSkip(
        by inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameAnswers.append(nil)
                
                if self.isLastQuestion {
                    self.submitResult()
                }
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func submitResult() {
        let gameAnswer = GameAnswerFactory().createFinalGameAnswerWith(
            gameAnswers: self.gameAnswers,
            mainIngredients: self.mainIngredients,
            menuNations: self.menuNations
        )

        let selectedDislikedFoods = RealmManager.shared.read()
        let resultSubmission = ResultSubmission(
            gameAnswer: gameAnswer,
            dislikedFoods: selectedDislikedFoods,
            pinNumber: self.pinNumber,
            token: AppDelegate.token
        )
        let encodedData = JSONParser().encode(from: resultSubmission)
        
        _ = NetworkProvider().request(api: WhatWeEatURL.ResultSubmissionAPI(pinNumber: self.pinNumber, body: encodedData))
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, soloGameResult) in
                if let decodedSoloGameResult = JSONParser<GameResult>().decode(from: soloGameResult) {
                    self.showNextPage(with: decodedSoloGameResult)
                } else {
                    self.showNextPage(with: nil)
                    UserDefaults.standard.set(true, forKey: Text.isTogetherGameSubmittedKey)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showNextPage(with soloGameResult: GameResult?) {
        if let pinNumber = self.pinNumber {
            self.coordinator.showSubmissionPage(pinNumber: pinNumber)
        } else {
            self.coordinator.showGameResultPage(with: nil, soloGameResult: soloGameResult)
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
    
    private func configurePreviousCardIndicies(
        by inputObserver: Observable<Void>
    ) -> Observable<(CardIndicies, Bool?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies, Bool?)> in
                if self.gameAnswers.isEmpty == false {
                    self.visibleCardIndices = self.previousVisibleCardIndices(from: self.visibleCardIndices)
                    let lastestAnswer = self.gameAnswers.removeLast()
                    
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
    
    private func configureMenuNationsSelectedindexPath(
        by inputObserver: Observable<IndexPath>
    ) -> Observable<IndexPath> {
        return inputObserver
            .withUnretained(self)
            .map { (self, indexPath) in
                guard let selectedMenuNation = self.menuNations[safe: indexPath.row] else { return IndexPath() }
                selectedMenuNation.toggleChecked()
                
                return indexPath
            }
    }
    
    private func configureMainIngredientsSelectedindexPath(
        by inputObserver: Observable<IndexPath>
    ) -> Observable<IndexPath> {
        return inputObserver
            .withUnretained(self)
            .map { (self, indexPath) in
                guard let selectedMenuNation = self.mainIngredients[safe: indexPath.row] else { return IndexPath() }
                selectedMenuNation.toggleChecked()
                
                return indexPath
            }
    }
}

extension CardGameViewModel {
    private enum Text {
        static let koreanDescriptionText = "??????"
        static let westernDescriptionText = "??????"
        static let japaneseDescriptionText = "??????"
        static let chineseDescriptionText = "??????"
        static let convenientDescriptionText = "??????"
        static let exoticDescriptionText = "????????????\n(?????????)"
        static let etcDescriptionText = "??????\n(?????????, ??????)"
        static let riceDescriptionText = "???"
        static let noodleDescriptionText = "???"
        static let soupDescriptionText = "???"
        static let hateAllDescriptionText = "???, ???, ??? ??? ??????\n(??????, ?????????, ??????)"
        static let isTogetherGameSubmittedKey = "isTogetherGameSubmitted"
    }
}

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
            .flatMap { (owner, _) -> Observable<(CardIndicies, String?)> in
                return Observable.just((owner.visibleCardIndices, owner.pinNumber))
            }
    }
    
    private func configureMenuNations(by inputObserver: Observable<Void>) -> Observable<[MenuNation]> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<[MenuNation]> in
                return Observable.just(owner.createMenuNations())
            }
    }
    
    private func configureMainIngredients(by inputObserver: Observable<Void>) -> Observable<[MainIngredient]> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<[MainIngredient]> in
                return Observable.just(owner.createMainIngredients())
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
            .flatMap { (owner, _) -> Observable<CardIndicies> in
                owner.visibleCardIndices = owner.nextVisibleCardIndices(from: owner.visibleCardIndices)
                owner.gameAnswers.append(true)
                
                return Observable.just(owner.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenHate(
        by inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<(CardIndicies)> in
                owner.visibleCardIndices = owner.nextVisibleCardIndices(from: owner.visibleCardIndices)
                owner.gameAnswers.append(false)
                
                return Observable.just(owner.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenSkip(
        by inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<(CardIndicies)> in
                owner.visibleCardIndices = owner.nextVisibleCardIndices(from: owner.visibleCardIndices)
                owner.gameAnswers.append(nil)
                
                if owner.isLastQuestion {
                    owner.submitResult()
                }
                
                return Observable.just(owner.visibleCardIndices)
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
            .subscribe(onNext: { (owner, soloGameResult) in
                if let decodedSoloGameResult = JSONParser<GameResult>().decode(from: soloGameResult) {
                    owner.showNextPage(with: decodedSoloGameResult)
                } else {
                    owner.showNextPage(with: nil)
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
            .flatMap { (owner, _) -> Observable<(CardIndicies, Bool?)> in
                if owner.gameAnswers.isEmpty == false {
                    owner.visibleCardIndices = owner.previousVisibleCardIndices(from: owner.visibleCardIndices)
                    let lastestAnswer = owner.gameAnswers.removeLast()
                    
                    return Observable.just((owner.visibleCardIndices, lastestAnswer))
                } else {
                    return Observable.just((owner.visibleCardIndices, nil))
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
            .map { (owner, indexPath) in
                guard let selectedMenuNation = owner.menuNations[safe: indexPath.row] else { return IndexPath() }
                selectedMenuNation.toggleChecked()
                
                return indexPath
            }
    }
    
    private func configureMainIngredientsSelectedindexPath(
        by inputObserver: Observable<IndexPath>
    ) -> Observable<IndexPath> {
        return inputObserver
            .withUnretained(self)
            .map { (owner, indexPath) in
                guard let selectedMenuNation = owner.mainIngredients[safe: indexPath.row] else { return IndexPath() }
                selectedMenuNation.toggleChecked()
                
                return indexPath
            }
    }
}

extension CardGameViewModel {
    private enum Text {
        static let koreanDescriptionText = "한식"
        static let westernDescriptionText = "양식"
        static let japaneseDescriptionText = "일식"
        static let chineseDescriptionText = "중식"
        static let convenientDescriptionText = "분식"
        static let exoticDescriptionText = "이국음식\n(아시안)"
        static let etcDescriptionText = "기타\n(샐러드, 치킨)"
        static let riceDescriptionText = "밥"
        static let noodleDescriptionText = "면"
        static let soupDescriptionText = "국"
        static let hateAllDescriptionText = "밥, 면, 국 다 싫어\n(치킨, 떡볶이, 딤섬)"
        static let isTogetherGameSubmittedKey = "isTogetherGameSubmitted"
    }
}

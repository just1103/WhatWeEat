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
    private var visibleCardIndices = (first: 0, second: 1, third: 2)
    private var menuNations = [MenuNation]()
    private var mainIngredients = [MainIngredient]()
    private var gameResults = [Bool?]()
    private var isLastQuestion: Bool {
        return gameResults.count >= 9
    }
    private let pinNumber: String?
    
    // MARK: - Initializers
    init(coordinator: GameCoordinator, pinNumber: String?) {
        self.coordinator = coordinator
        self.pinNumber = pinNumber
    }
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output { 
        let initialCardIndiciesAndPinNumber = configureInitialCardIndiciesAndPinNumber(with: input.invokedViewDidLoad)
        let menuNations = configureMenuNations(with: input.invokedViewDidLoad)
        let mainIngredients = configureMainIngredients(with: input.invokedViewDidLoad)
        let nextCardIndiciesWhenLike = configureNextCardIndiciesWhenLike(with: input.likeButtonDidTap)
        let nextCardIndiciesWhenHate = configureNextCardIndiciesWhenHate(with: input.hateButtonDidTap)
        let nextCardIndiciesWhenSkip = configureNextCardIndiciesWhenSkip(with: input.skipButtonDidTap)
        let previousCardIndicies = configurePreviousCardIndicies(with: input.previousQuestionButtonDidTap)
        let menuNationsSelectedindexPath = configureMenuNationsSelectedindexPath(
            with: input.menuNationsCellDidSelect
        )
        let mainIngredientsSelectedindexPath = configureMainIngredientsSelectedindexPath(
            with: input.mainIngredientsCellDidSelect
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
        with inputObserver: Observable<Void>
    ) -> Observable<(CardIndicies, String?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies, String?)> in
                return Observable.just((self.visibleCardIndices, self.pinNumber))
            }
    }
    
    private func configureMenuNations(with inputObserver: Observable<Void>) -> Observable<[MenuNation]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MenuNation]> in
                return Observable.just(self.createMenuNations())
            }
    }
    
    private func configureMainIngredients(with inputObserver: Observable<Void>) -> Observable<[MainIngredient]> {
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
        menuNations = [korean, western, japanese, chinese, convenient, exotic, etc]
        
        return menuNations
    }
    
    private func createMainIngredients() -> [MainIngredient] {
        let rice = MainIngredient(kind: .rice, descriptionText: "밥")
        let noodle = MainIngredient(kind: .noodle, descriptionText: "면")
        let soup = MainIngredient(kind: .soup, descriptionText: "국")
        let hateAll = MainIngredient(kind: .hateAll, descriptionText: "밥, 면, 국 다 싫어\n(치킨, 떡볶이, 딤섬)")
        mainIngredients = [rice, noodle, soup, hateAll]
        
        return mainIngredients
    }
    
    private func configureNextCardIndiciesWhenLike(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<CardIndicies> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameResults.append(true)
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenHate(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameResults.append(false)
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func configureNextCardIndiciesWhenSkip(
        with inputObserver: Observable<Void>
    ) -> Observable<CardIndicies> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies)> in
                self.visibleCardIndices = self.nextVisibleCardIndices(from: self.visibleCardIndices)
                self.gameResults.append(nil)
                
                if self.isLastQuestion {
                    self.submitResult()
                }
                
                return Observable.just(self.visibleCardIndices)
            }
    }
    
    private func submitResult() {
        let selectedNations = self.menuNations.filter { $0.isChecked }
            .map { $0.kind }
        let selectedMainIngredient = self.mainIngredients.filter { $0.isChecked }
            .map { $0.kind }
        
        // 서버에서 로직 처리 (좋아=true, 싫어=false, 상관없음=nil)
        // 향후 "면 싫어 Cell" 등이 추가될 수 있음
        var isRiceChecked = selectedMainIngredient.contains(.rice) ? true : nil
        var isNoodleChecked = selectedMainIngredient.contains(.noodle) ? true : nil
        var isSoupChecked = selectedMainIngredient.contains(.soup) ? true : nil
        let isAllHateChecked = selectedMainIngredient.contains(.hateAll)
        
        if isAllHateChecked {
            isRiceChecked = false
            isNoodleChecked = false
            isSoupChecked = false
        }
        
        guard
            let hangoverGameAnswer = self.gameResults[safe: 0],
            let greasyGameAnswer = self.gameResults[safe: 1],
            let healthGameAnswer = self.gameResults[safe: 2],
            let alcoholGameAnswer = self.gameResults[safe: 3],
            let instantGameAnswer = self.gameResults[safe: 4],
            let spicyGameAnswer = self.gameResults[safe: 5],
            let richGameAnswer = self.gameResults[safe: 6]
        else { return }
        
        let gameAnswer = GameAnswer(
            hangover: hangoverGameAnswer,
            greasy: greasyGameAnswer,
            health: healthGameAnswer,
            alcohol: alcoholGameAnswer,
            instant: instantGameAnswer,
            spicy: spicyGameAnswer,
            rich: richGameAnswer,
            rice: isRiceChecked,
            noodle: isNoodleChecked,
            soup: isSoupChecked,
            nation: selectedNations
        )

        let selectedDislikedFoods = RealmManager.shared.read()
        let resultSubmission = ResultSubmission(
            gameAnswer: gameAnswer,
            dislikedFoods: selectedDislikedFoods,
            pinNumber: self.pinNumber,
            token: "111"  // TODO: token 연결
        )
        let encodedData = JSONParser().encode(from: resultSubmission)
        
        _ = NetworkProvider().request(api: WhatWeEatURL.ResultSubmissionAPI(pinNumber: self.pinNumber, body: encodedData))
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.showNextPage()
            }) 
    }
    
    private func showNextPage() {
        if let pinNumber = self.pinNumber {
            // TODO: 화면전환 - together 결과대기화면
            guard
                let mainTabBarController = self.coordinator.navigationController?.viewControllers.first as? MainTabBarController
            else { return }
            
            mainTabBarController.showTabBar()
            self.coordinator.showSubmissionPage(pinNumber: pinNumber)
        } else {
            // TODO: 화면전환 - Solo 결과확인
//          self.coordinator
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
        with inputObserver: Observable<Void>
    ) -> Observable<(CardIndicies, Bool?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(CardIndicies, Bool?)> in
                if self.gameResults.isEmpty == false {
                    self.visibleCardIndices = self.previousVisibleCardIndices(from: self.visibleCardIndices)
                    let lastestAnswer = self.gameResults.removeLast()
                    
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
        with inputObserver: Observable<IndexPath>
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
        with inputObserver: Observable<IndexPath>
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

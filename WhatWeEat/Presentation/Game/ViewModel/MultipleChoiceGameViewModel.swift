import Foundation
import RxSwift

final class MultipleChoiceGameViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let cellDidSelect: Observable<IndexPath>
    }
    
    struct Output {
        let menuNations: Observable<[MenuNation]>
        let selectedIndexPathAndCount: Observable<(IndexPath, Int)>
    }
    
    // MARK: - Properties
    private weak var coordinator: GameCoordinator!
    private var menuNations = [MenuNation]()
    private let mainIngredients = ["밥", "면", "국물", "밥, 면, 국물 다 싫어\n(치킨, 떡볶이, 딤섬)"]
    private let cardGameResults: [Bool?]
    
    // MARK: - Initializers
    init(cardGameResults: [Bool?], coordinator: GameCoordinator) {
        self.cardGameResults = cardGameResults
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let menuNations = configureMenuNationsObservable(with: input.invokedViewDidLoad)
        let selectedIndexPathAndCount = configureSelectedIndexPathObservable(with: input.cellDidSelect)
        let ouput = Output(menuNations: menuNations, selectedIndexPathAndCount: selectedIndexPathAndCount)
        
        return ouput
    }
    
    private func configureMenuNationsObservable(with inputObserver: Observable<Void>) -> Observable<[MenuNation]> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<[MenuNation]> in
                let korean = MenuNation(kind: .korean, descriptionText: "한식")
                let western = MenuNation(kind: .western, descriptionText: "양식")
                let japanese = MenuNation(kind: .japanese, descriptionText: "일식")
                let chinese = MenuNation(kind: .chinese, descriptionText: "중식")
                let convenient = MenuNation(kind: .convenient, descriptionText: "분식")
                let exotic = MenuNation(kind: .exotic, descriptionText: "이국음식\n(아시안)")
                let etc = MenuNation(kind: .etc, descriptionText: "기타\n(샐러드, 치킨)")
                self.menuNations = [korean, western, japanese, chinese, convenient, exotic, etc]
                return Observable.just(self.menuNations)
            }
    }
    
    private func configureSelectedIndexPathObservable(with inputObserver: Observable<IndexPath>) -> Observable<(IndexPath, Int)> {
        return inputObserver
            .withUnretained(self)
            .map { (self, indexPath) in
                guard let selectedMenuNation = self.menuNations[safe: indexPath.row] else { return (IndexPath(), 0) }
                selectedMenuNation.toggleChecked()
                let selectedCount = self.menuNations.filter { $0.isChecked }.count
                
                return (indexPath, selectedCount)
            }
    }
}

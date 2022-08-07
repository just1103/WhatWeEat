import UIKit
import RxSwift
import RealmSwift

final class DislikedFoodSurveyViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let cellDidSelect: Observable<IndexPath>
        let confirmButtonDidTap: Observable<Void>
    }

    struct Output {
        let dislikedFoods: Observable<[DislikedFood]>
        let selectedFoodIndexPath: Observable<IndexPath>
    }
    
    // MARK: - Properties
    private weak var coordinator: DislikedFoodSurveyPresentable!
    private var dislikedFoods = [DislikedFood]()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: DislikedFoodSurveyPresentable) {
        self.coordinator = coordinator
    }
    
    deinit {
        guard let onboardingCoordinator = coordinator as? OnboardingCoordinator else { return }
        onboardingCoordinator.finish()
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let dislikedFoods = configureDislikedFoods(by: input.invokedViewDidLoad)
        let selectedFood = configureSelectedFoodIndexPathObservable(by: input.cellDidSelect)
        configureconfirmButtonDidTapObservable(by: input.confirmButtonDidTap)

        let output = Output(
            dislikedFoods: dislikedFoods,
            selectedFoodIndexPath: selectedFood
        )

        return output
    }

    private func configureDislikedFoods(by inputObserver: Observable<Void>) -> Observable<[DislikedFood]> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<[DislikedFood]> in
                guard
                    let intestineFoodImage = Content.intestineFoodImage,
                    let sashimiFoodImage = Content.sashimiFoodImage,
                    let seaFoodImage = Content.seaFoodImage,
                    let meatFoodImage = Content.meatFoodImage
                else {
                    return Observable.just([])
                }
                
                let intestineFood = DislikedFood(
                    kind: .intestine,
                    descriptionImage: intestineFoodImage,
                    descriptionText: Text.intestineFoodText
                )
                let sashimiFood = DislikedFood(
                    kind: .sashimi,
                    descriptionImage: sashimiFoodImage,
                    descriptionText: Text.sashimiFoodText
                )
                let seaFood = DislikedFood(
                    kind: .seafood,
                    descriptionImage: seaFoodImage,
                    descriptionText: Text.seaFoodText
                )
                let meatFood = DislikedFood(
                    kind: .meat,
                    descriptionImage: meatFoodImage,
                    descriptionText: Text.meatFoodText
                )
                owner.dislikedFoods = [intestineFood, sashimiFood, seaFood, meatFood]
                
                let realmManager = RealmManager.shared
                let checkedFoodsFromRealm = realmManager.read()
                
                _ = owner.dislikedFoods.filter { checkedFoodsFromRealm.contains($0.kind) }
                    .map { $0.toggleChecked() }
                
                return Observable.just(owner.dislikedFoods)
            }
    }
    
    private func configureSelectedFoodIndexPathObservable(by inputObserver: Observable<IndexPath>) -> Observable<IndexPath> {
        return inputObserver
            .withUnretained(self)
            .map { (owner, indexPath) in
            guard let selectedDislikedFood = owner.dislikedFoods[safe: indexPath.row] else { return IndexPath() }
            selectedDislikedFood.toggleChecked()
            return indexPath
        }
    }
    
    private func configureconfirmButtonDidTapObservable(by inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let checkedFoods = owner.dislikedFoods.filter { $0.isChecked }
                
                let realmManger = RealmManager.shared
                realmManger.deleteAndCreate(checkedFoods)
                
                if FirstLaunchChecker.isFirstLaunched() {
                    owner.coordinator.dislikedFoodSurveyCoordinatorDelegate.showMainTabBarPage()
                    UserDefaults.standard.set(false, forKey: Text.isFirstLaunchedKey)
                } else {
                    guard let settingCoordinator = owner.coordinator as? SettingCoordinator else { return }
                    settingCoordinator.popCurrentPage()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Namespaces
extension DislikedFoodSurveyViewModel {
    private enum Content {
        static let intestineFoodImage = UIImage(named: "intestine")
        static let sashimiFoodImage = UIImage(named: "sashimi")
        static let seaFoodImage = UIImage(named: "fish")
        static let meatFoodImage = UIImage(named: "meat")
    }
    
    private enum Text {
        static let intestineFoodText = "내장"
        static let sashimiFoodText = "날 것 (회, 육회)"
        static let seaFoodText = "해산물"
        static let meatFoodText = "고기"
        
        static let isFirstLaunchedKey = "isFirstLaunched"
    }
}

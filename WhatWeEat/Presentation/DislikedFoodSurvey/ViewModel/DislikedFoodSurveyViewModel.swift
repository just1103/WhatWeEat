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
        inputObserver.flatMap { [weak self] _ -> Observable<[DislikedFood]> in
            guard
                let self = self,
                let chilliFoodImage = UIImage(named: "chilli"),
                let intestineFoodImage = UIImage(named: "intestine"),
                let sashimiFoodImage = UIImage(named: "sashimi"),
                let seaFoodImage = UIImage(named: "fish"),
                let meatFoodImage = UIImage(named: "meat")
            else {
                return Observable.just([])
            }
            let chilliFood = DislikedFood(kind: .spicy, descriptionImage: chilliFoodImage, descriptionText: "매콤한 음식")
            let intestineFood = DislikedFood(kind: .intestine, descriptionImage: intestineFoodImage, descriptionText: "내장")
            let sashimiFood = DislikedFood(kind: .sashimi, descriptionImage: sashimiFoodImage, descriptionText: "날 것 (회, 육회)")
            let seaFood = DislikedFood(kind: .seafood, descriptionImage: seaFoodImage, descriptionText: "해산물")
            let meatFood = DislikedFood(kind: .meat, descriptionImage: meatFoodImage, descriptionText: "고기")
            self.dislikedFoods = [chilliFood, intestineFood, sashimiFood, seaFood, meatFood]
              
            let realmManager = RealmManager.shared
            let checkedFoodsFromRealm = realmManager.read()
            
            _ = self.dislikedFoods.filter { checkedFoodsFromRealm.contains($0.kind) }
                .map { $0.toggleChecked() }
            
            return Observable.just(self.dislikedFoods)
        }
    }
    
    private func configureSelectedFoodIndexPathObservable(by inputObserver: Observable<IndexPath>) -> Observable<IndexPath> {
        return inputObserver.map { [weak self] indexPath in
            guard let selectedDislikedFood = self?.dislikedFoods[safe: indexPath.row] else { return IndexPath() }
            selectedDislikedFood.toggleChecked()
            return indexPath
        }
    }
    
    private func configureconfirmButtonDidTapObservable(by inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                let checkedFoods = self.dislikedFoods.filter { $0.isChecked }
                
                let realmManger = RealmManager.shared
                realmManger.deleteAndCreate(checkedFoods)
                
                if FirstLaunchChecker.isFirstLaunched() {
                    self.coordinator.dislikedFoodSurveyCoordinatorDelegate.showMainTabBarPage()
                    UserDefaults.standard.set(false, forKey: "isFirstLaunched")
                } else {
                    guard let settingCoordinator = self.coordinator as? SettingCoordinator else { return }
                    settingCoordinator.popCurrentPage()
                }
            })
            .disposed(by: disposeBag)
    }
}

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
        let dislikedFoods: Observable<[DislikedFoodCell.DislikedFood]>
        let selectedFoodIndexPath: Observable<IndexPath>
    }
    
    // MARK: - Properties
    private let actions: DislikedFoodSurveyViewModelAction!
    private var dislikedFoods = [DislikedFoodCell.DislikedFood]()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(actions: DislikedFoodSurveyViewModelAction) {
        self.actions = actions
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

    private func configureDislikedFoods(by inputObserver: Observable<Void>) -> Observable<[DislikedFoodCell.DislikedFood]> {
        inputObserver.flatMap { [weak self] _ -> Observable<[DislikedFoodCell.DislikedFood]> in
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
            let chilliFood = DislikedFoodCell.DislikedFood(name: "매움", descriptionImage: chilliFoodImage, descriptionText: "매콤한 음식")
            let intestineFood = DislikedFoodCell.DislikedFood(name: "내장", descriptionImage: intestineFoodImage, descriptionText: "내장")
            let sashimiFood = DislikedFoodCell.DislikedFood(name: "날것", descriptionImage: sashimiFoodImage, descriptionText: "날 것 (회, 육회)")
            let seaFood = DislikedFoodCell.DislikedFood(name: "해산물", descriptionImage: seaFoodImage, descriptionText: "해산물")
            let meatFood = DislikedFoodCell.DislikedFood(name: "고기", descriptionImage: meatFoodImage, descriptionText: "고기")
            self.dislikedFoods = [chilliFood, intestineFood, sashimiFood, seaFood, meatFood]
              
            let realmManager = RealmManager.shared
            let checkedFoodsFromRealm = realmManager.read()
            
            _ = self.dislikedFoods.filter { checkedFoodsFromRealm.contains($0.name) }
                .map { $0.toggleChecked() }
            
            return Observable.just(self.dislikedFoods)
        }
    }
    
    private func configureSelectedFoodIndexPathObservable(by inputObserver: Observable<IndexPath>) -> Observable<IndexPath> {
        return inputObserver.map { [weak self] indexPath in
            self?.dislikedFoods[indexPath.row].toggleChecked()
            return indexPath
        }
    }
    
    private func configureconfirmButtonDidTapObservable(by inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let checkedFoods = self.dislikedFoods
                    .filter { $0.isChecked }
                
                let realmManger = RealmManager.shared
                realmManger.deleteAndCreate(checkedFoods)
                
                if FirstLaunchChecker.isFirstLaunched() {
                    UserDefaults.standard.set(false, forKey: "isFirstLaunched")
                    self.actions.showMainTapBarPage()
                } else {
                    guard let popCurrentPage = self.actions.popCurrentPage else { return }
                    popCurrentPage()
                }
            })
            .disposed(by: disposeBag)
       }
}

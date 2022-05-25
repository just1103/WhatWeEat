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
        let confirmButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private var dislikedFoods = [DislikedFoodCell.DislikedFood]()
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let dislikedFoods = configureDislikedFoods(by: input.invokedViewDidLoad)
        let selectedFood = configureSelectedFoodIndexPathObservable(by: input.cellDidSelect)
        let confirmButtonDidTap = configureconfirmButtonDidTapObservable(by: input.confirmButtonDidTap)

        let output = Output(
            dislikedFoods: dislikedFoods,
            selectedFoodIndexPath: selectedFood,
            confirmButtonDidTap: confirmButtonDidTap
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
            let chilliFood = DislikedFoodCell.DislikedFood(descriptionImage: chilliFoodImage, descriptionText: "매콤한 음식")
            let intestineFood = DislikedFoodCell.DislikedFood(descriptionImage: intestineFoodImage, descriptionText: "내장")
            let sashimiFood = DislikedFoodCell.DislikedFood(descriptionImage: sashimiFoodImage, descriptionText: "날 것 (회, 육회)")
            let seaFood = DislikedFoodCell.DislikedFood(descriptionImage: seaFoodImage, descriptionText: "해산물")
            let meatFood = DislikedFoodCell.DislikedFood(descriptionImage: meatFoodImage, descriptionText: "고기")

            self.dislikedFoods = [chilliFood, intestineFood, sashimiFood, seaFood, meatFood]
            return Observable.just(self.dislikedFoods)
        }
    }
    
    private func configureSelectedFoodIndexPathObservable(by inputObserver: Observable<IndexPath>) -> Observable<IndexPath> {
        return inputObserver.map { [weak self] indexPath in
            self?.dislikedFoods[indexPath.row].isChecked.toggle()
            return indexPath
        }
    }
    
    private func configureconfirmButtonDidTapObservable(by inputObserver: Observable<Void>) -> Observable<Void> {
        return inputObserver.map { [weak self] in
            let realm = RealmManager.shared.realm
            
            try! realm.write {
                realm.deleteAll()
                
                _ = self?.dislikedFoods
                    .filter { $0.isChecked }
                    .map {
                        let dislikedFood = DislikedFoodForRealM(name: $0.descriptionText)
                        realm.add(dislikedFood)
                    }
            }
        }
    }
}
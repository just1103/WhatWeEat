import UIKit
import RxSwift

final class DislikedFoodSurveyViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
    }

    struct Output {
        let dislikedFoods: Observable<[DislikedFoodCell.DislikedFood]>
    }
    
    // MARK: - Properties
    private var dislikedFoods = [DislikedFoodCell.DislikedFood]()
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let dislikedFoods = configureDislikedFoods(by: input.invokedViewDidLoad)

        let output = Output(dislikedFoods: dislikedFoods)

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
            // TODO: var 확인
            let chilliFood = DislikedFoodCell.DislikedFood(descriptionImage: chilliFoodImage, descriptionText: "매콤한 음식")
            let intestineFood = DislikedFoodCell.DislikedFood(descriptionImage: intestineFoodImage, descriptionText: "내장")
            let sashimiFood = DislikedFoodCell.DislikedFood(descriptionImage: sashimiFoodImage, descriptionText: "날 것 (회, 육회)")
            let seaFood = DislikedFoodCell.DislikedFood(descriptionImage: seaFoodImage, descriptionText: "해산물")
            let meatFood = DislikedFoodCell.DislikedFood(descriptionImage: meatFoodImage, descriptionText: "고기")

            self.dislikedFoods = [chilliFood, intestineFood, sashimiFood, seaFood, meatFood]
            return Observable.just(self.dislikedFoods)
        }
    }
}

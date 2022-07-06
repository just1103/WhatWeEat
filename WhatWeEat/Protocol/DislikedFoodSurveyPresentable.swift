import Foundation

protocol DislikedFoodSurveyPresentable: AnyObject {
    var dislikedFoodSurveyCoordinatorDelegate: DislikedFoodSurveyCoordinatorDelegate! { get set }
    
    func finish()
}

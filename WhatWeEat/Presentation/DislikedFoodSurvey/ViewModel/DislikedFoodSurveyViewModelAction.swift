import Foundation

struct DislikedFoodSurveyViewModelAction {
    let showMainTapBarPage: () -> Void
    let popCurrentPage: (() -> Void)?
}

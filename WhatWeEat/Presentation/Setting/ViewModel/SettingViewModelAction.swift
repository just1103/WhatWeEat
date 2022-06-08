import Foundation

struct SettingViewModelAction {
    let showDislikedFoodSurveyPage: () -> Void
    let showSettingDetailPage: (String, String) -> Void
}

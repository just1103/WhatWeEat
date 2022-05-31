import Foundation
import RxSwift

protocol SettingItem {
    var title: String { get }
    var sectionKind: SettingViewController.SectionKind { get }
}

final class SettingViewModel {
    // MARK: - NestedTypes
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let backButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let tableViewItems: Observable<[SettingItem]>
        let backButtonDidTap: Observable<Void>
    }
    
    struct OrdinarySettingItem: SettingItem {
        let title: String
        let content: String?
        let sectionKind: SettingViewController.SectionKind
    }
    
    struct VersionSettingItem: SettingItem {
        let title: String
        let subtitle: String
        let buttonTitle: String
        let sectionKind: SettingViewController.SectionKind = .version
    }
    
    func transform(_ input: Input) -> Output {
        let tableViewItems = configureTableViewItems(with: input.invokedViewDidLoad)
        let ouput = Output(tableViewItems: tableViewItems, backButtonDidTap: input.backButtonDidTap)
        
        return ouput
    }
    
    private func configureTableViewItems(with inputObserver: Observable<Void>) -> Observable<[SettingItem]> {
        inputObserver
            .flatMap { () -> Observable<[SettingItem]> in
                let editDislikedFoods = OrdinarySettingItem(
                    title: Content.editDislikedFoodsTitle,
                    content: Content.editDislikedFoodsContent,
                    sectionKind: .dislikedFood
                )
                let privacyPolicies = OrdinarySettingItem(
                    title: Content.privacyPoliciesTitle,
                    content: Content.privacyPoliciesContent,
                    sectionKind: .ordinarySetting
                )
                let openSourceLicense = OrdinarySettingItem(
                    title: Content.openSourceLicenseTitle,
                    content: Content.openSourceLicenseContent,
                    sectionKind: .ordinarySetting
                )
                let feedBackToDeveloper = OrdinarySettingItem(
                    title: Content.feedBackToDeveloperTitle,
                    content: Content.feedBackToDeveloperContent,
                    sectionKind: .ordinarySetting
                )
                let recommendToFriend = OrdinarySettingItem(
                    title: Content.recommendToFriendTitle,
                    content: Content.recommendToFriendContent,
                    sectionKind: .ordinarySetting
                )
                let versionInformation = VersionSettingItem(
                    title: Content.versionInformationTitle,
                    subtitle: Content.versionInformationSubtitle,
                    buttonTitle: Content.versionInformationButtonLatestTitle
                )
                let settingItems: [SettingItem] = [
                    editDislikedFoods, privacyPolicies, openSourceLicense, feedBackToDeveloper, recommendToFriend, versionInformation
                ]
                
                return Observable.just(settingItems)
            }
    }
}

// MARK: - NameSpaces
extension SettingViewModel {
    enum Content {
        static let editDislikedFoodsTitle = "못먹는 음식 수정하기"
        static let editDislikedFoodsContent = ""
        static let privacyPoliciesTitle = "개인정보 처리방침"
        static let privacyPoliciesContent = ""
        static let openSourceLicenseTitle = "오픈소스 라이센스"
        static let openSourceLicenseContent = ""
        static let feedBackToDeveloperTitle = "개발자에게 피드백하기"
        static let feedBackToDeveloperContent = ""
        static let recommendToFriendTitle = "친구에게 추천하기"
        static let recommendToFriendContent = ""
        static let versionInformationTitle = "버전 정보"
        static let versionInformationSubtitle = "현재 1.0 / 최신 1.0"
        static let versionInformationButtonUpdateTitle = "업데이트"
        static let versionInformationButtonLatestTitle = "최신버전"
    }
}


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
        let settingItemDidSelect: Observable<IndexPath>
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
    
    // MARK: - Properties
    private var actions: SettingViewModelAction!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(actions: SettingViewModelAction) {
        self.actions = actions
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let tableViewItems = configureTableViewItems(with: input.invokedViewDidLoad)
        configureSettingItemDidSelectObservable(with: input.settingItemDidSelect)
        
        let ouput = Output(tableViewItems: tableViewItems, backButtonDidTap: input.backButtonDidTap)

        return ouput
    }
    
    private func configureTableViewItems(with inputObserver: Observable<Void>) -> Observable<[SettingItem]> {
        inputObserver
            .flatMap { [weak self] () -> Observable<[SettingItem]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                let editDislikedFoods = OrdinarySettingItem(
                    title: Content.editDislikedFoodsTitle,
                    content: Content.editDislikedFoodsContent,
                    sectionKind: .dislikedFood
                )
                let privacyPolicies = OrdinarySettingItem(
                    title: Content.privacyPoliciesTitle,
                    content: Content.privacyPoliciesContent,
                    sectionKind: .ordinary
                )
                let openSourceLicense = OrdinarySettingItem(
                    title: Content.openSourceLicenseTitle,
                    content: Content.openSourceLicenseContent,
                    sectionKind: .ordinary
                )
                let feedBackToDeveloper = OrdinarySettingItem(
                    title: Content.feedBackToDeveloperTitle,
                    content: Content.feedBackToDeveloperContent,
                    sectionKind: .ordinary
                )
                let recommendToFriend = OrdinarySettingItem(
                    title: Content.recommendToFriendTitle,
                    content: Content.recommendToFriendContent,
                    sectionKind: .ordinary
                )
                let versionInformation = VersionSettingItem(
                    title: Content.versionInformationTitle,
                    subtitle: self.configureVersionInformationSubtitle(),
                    buttonTitle: self.configureVersionInformationButtonUpdateTitle()
                )
                let settingItems: [SettingItem] = [
                    editDislikedFoods, privacyPolicies, openSourceLicense, feedBackToDeveloper, recommendToFriend, versionInformation
                ]
                
                return Observable.just(settingItems)
            }
    }
    
    private func configureVersionInformationSubtitle() -> String {
        let currentAppVersion = checkCurrentAppVersion()
        let latestAppVersion = checkLatestAppVersion()
        return "현재 \(currentAppVersion) / 최신 \(latestAppVersion)"
    }
    
    private func checkCurrentAppVersion() -> String {
        guard let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return Content.versionCheckErrorTitle
        }
        return currentAppVersion
    }
    
    private func checkLatestAppVersion() -> String {
        let appBundleID = "com.WhatWeEat"
        
        guard
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appBundleID)"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["reslts"] as? [[String: Any]],
            results.count > 0,
            let latestAppVersion = results[0]["version"] as? String
        else {
//            return "1.0"  // TODO: 테스트코드
            return Content.versionCheckErrorTitle
        }
        
        return latestAppVersion
    }
    
    private func configureVersionInformationButtonUpdateTitle() -> String {
        if isUpdateNeeded() {
            return Content.versionInformationButtonUpdateTitle
        } else {
            return Content.versionInformationButtonLatestTitle
        }
    }
    
    private func isUpdateNeeded() -> Bool {
        let currentAppVersion = checkCurrentAppVersion()
        let latestAppVersion = checkLatestAppVersion()
        
        return currentAppVersion == latestAppVersion ? false : true
    }
    
    private func configureSettingItemDidSelectObservable(with inputObserver: Observable<IndexPath>) {
        inputObserver
            .subscribe(onNext: { [weak self] indexPath in
                guard let sectionKind = SettingViewController.SectionKind(rawValue: indexPath.section) else { return }
                switch sectionKind {
                case .dislikedFood:
                    self?.actions.showDislikedFoodSurveyPage()
                case .ordinary:
                    print("!!!")
                case .version:
                    return
                }
            })
            .disposed(by: disposeBag)
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
        static let versionCheckErrorTitle = "버전 확인 불가"
        static let versionInformationButtonUpdateTitle = "업데이트"
        static let versionInformationButtonLatestTitle = "최신버전"
    }
}

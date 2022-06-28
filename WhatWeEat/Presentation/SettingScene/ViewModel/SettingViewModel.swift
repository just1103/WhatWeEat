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
    
    struct CommonSettingItem: SettingItem {
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
    private weak var coordinator: SettingCoordinator!
    private var settingItems: [SettingItem] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let tableViewItems = configureTableViewItems(by: input.invokedViewDidLoad)
        configureSettingItemDidSelectObservable(by: input.settingItemDidSelect)
        
        let output = Output(tableViewItems: tableViewItems, backButtonDidTap: input.backButtonDidTap)

        return output
    }
    
    private func configureTableViewItems(by inputObserver: Observable<Void>) -> Observable<[SettingItem]> {
        inputObserver
            .flatMap { [weak self] () -> Observable<[SettingItem]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                let editDislikedFoods = CommonSettingItem(
                    title: Content.editDislikedFoodsTitle,
                    content: Content.editDislikedFoodsContent,
                    sectionKind: .dislikedFood
                )
                let privacyPolicies = CommonSettingItem(
                    title: Content.privacyPoliciesTitle,
                    content: try? String(contentsOfFile: FilePath.termsOfPrivacy),
                    sectionKind: .common
                )
                let openSourceLicense = CommonSettingItem(
                    title: Content.openSourceLicenseTitle,
                    content: try? String(contentsOfFile: FilePath.openSourceLicense),
                    sectionKind: .common
                )
                let feedBackToDeveloper = CommonSettingItem(
                    title: Content.feedBackToDeveloperTitle,
                    content: Content.feedBackToDeveloperContent,
                    sectionKind: .common
                )
                let recommendToFriend = CommonSettingItem(
                    title: Content.recommendToFriendTitle,
                    content: Content.recommendToFriendContent,
                    sectionKind: .common
                )
                let versionInformation = VersionSettingItem(
                    title: Content.versionInformationTitle,
                    subtitle: self.configureVersionInformationSubtitle(),
                    buttonTitle: self.configureVersionInformationButtonUpdateTitle()
                )
                self.settingItems = [
                    editDislikedFoods, privacyPolicies, openSourceLicense, feedBackToDeveloper, recommendToFriend, versionInformation
                ]
                
                return Observable.just(self.settingItems)
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
            let latestAppVersion = results[safe: 0]?["version"] as? String
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
    
    private func configureSettingItemDidSelectObservable(by inputObserver: Observable<IndexPath>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (self, indexPath) in
                guard let sectionKind = SettingViewController.SectionKind(rawValue: indexPath.section) else { return }
                
                switch sectionKind {
                case .dislikedFood:
                    self.coordinator.showDislikedFoodSurveyPage()
                case .common:
                    guard
                        let commonSettingItems = self.settingItems.filter({ $0.sectionKind == .common }) as? [CommonSettingItem],
                        let content = commonSettingItems[indexPath.row].content
                    else { return }
                    self.coordinator.showSettingDetailPageWith(title: commonSettingItems[indexPath.row].title, content: content)
                case .version:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NameSpaces
extension SettingViewModel {
    enum FilePath { 
        static let termsOfPrivacy = Bundle.main.path(forResource: "TermsOfPrivacy", ofType: "txt") ?? ""
        static let openSourceLicense = Bundle.main.path(forResource: "OpenSourceLicense", ofType: "txt") ?? ""
    }
    
    enum Content {
        static let editDislikedFoodsTitle = "못먹는 음식 수정하기"
        static let editDislikedFoodsContent = ""
        static let privacyPoliciesTitle = "개인정보 처리방침"
        static let openSourceLicenseTitle = "오픈소스 라이센스"
        static let feedBackToDeveloperTitle = "개발자에게 피드백하기"
        static let feedBackToDeveloperContent = """
        개발자 이메일: aaaa@gmail.com
        """
        static let recommendToFriendTitle = "친구에게 추천하기"
        static let recommendToFriendContent = ""
        static let versionInformationTitle = "버전 정보"
        static let versionCheckErrorTitle = "버전 확인 불가"
        static let versionInformationButtonUpdateTitle = "업데이트"
        static let versionInformationButtonLatestTitle = "최신버전"
    }
}

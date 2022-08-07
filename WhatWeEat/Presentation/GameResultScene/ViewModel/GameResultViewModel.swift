import Foundation
import RxSwift

final class GameResultViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
//        let restaurantCheckButtonDidTap: Observable<Void>
        let nextMenuCheckButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
        let gameRestartButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let firstMenuAndPlayerCountAndPinNumber: Observable<(Menu, Int, String?)>
        let nextMenu: Observable<(Menu?, Int)>
        let shareButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: GameCoordinator!
    private let pinNumber: String?
    private let soloGameResult: GameResult?
    private var menus = [Menu]()
    private var currentMenuIndex = 0
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: GameCoordinator, pinNumber: String?, soloGameResult: GameResult?) {
        self.coordinator = coordinator
        self.pinNumber = pinNumber
        self.soloGameResult = soloGameResult
    }
    
    deinit {
        coordinator.finish()
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let firstMenuAndPlayerCountAndPinNumber = configureFirstMenuAndPlayerCountAndPinNumber(by: input.invokedViewDidLoad)
//        configureRestaurantCheckButtonDidTap(with: input.restaurantCheckButtonDidTap)
        let nextMenu = configureNextMenuCheckButtonDidTap(by: input.nextMenuCheckButtonDidTap)
        configureGameRestartButtonDidTap(by: input.gameRestartButtonDidTap)

        let output = Output(
            firstMenuAndPlayerCountAndPinNumber: firstMenuAndPlayerCountAndPinNumber,
            nextMenu: nextMenu,
            shareButtonDidTap: input.shareButtonDidTap
        )

        return output
    }
    
    private func configureFirstMenuAndPlayerCountAndPinNumber(
        by inputObserver: Observable<Void>
    ) -> Observable<(Menu, Int, String?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<(Menu, Int, String?)> in
                if let pinNumber = owner.pinNumber {
                    return owner.fetchTogetherGameResult(with: owner.pinNumber)
                        .map { menusAndPlayerCount in
                            guard let firstMenu = menusAndPlayerCount.menus.first else {
                                return (Menu(name: "", imageURL: "", keywords: []), menusAndPlayerCount.playerCount, pinNumber)
                            }
                            
                            owner.menus = menusAndPlayerCount.menus
                            
                            return (firstMenu, menusAndPlayerCount.playerCount, pinNumber)
                        }
                } else {
                    guard let soloGameResult = owner.soloGameResult,
                          let firstMenu = soloGameResult.menus.first
                    else {
                        return Observable.just((Menu(name: "", imageURL: "", keywords: []), 1, nil))
                    }
                    
                    owner.menus = soloGameResult.menus
                    
                    return Observable.just((firstMenu, soloGameResult.playerCount, nil))
                }
            }
    }
    
    private func fetchTogetherGameResult(with pinNumber: String?) -> Observable<GameResult> {
        let menusAndPlayerCount = NetworkProvider().fetchData(
            api: WhatWeEatURL.GameResultAPI(pinNumber: pinNumber),
            decodingType: GameResult.self
        )
    
        return menusAndPlayerCount
    }
    
    private func configureNextMenuCheckButtonDidTap(by inputObserver: Observable<Void>) -> Observable<(Menu?, Int)> {
        inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<(Menu?, Int)> in
                owner.currentMenuIndex += 1
                
                return Observable.just((owner.menus[safe: owner.currentMenuIndex], owner.currentMenuIndex))
            }
    }

    private func configureGameRestartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, _) in
                if owner.pinNumber == nil {
                    owner.coordinator.showInitialSoloMenuPage()
                } else {
                    // 그룹 정보 삭제는 서버에서 처리 (1일 후 삭제)
                    owner.coordinator.showInitialTogetherMenuPage()
                }
                
                owner.coordinator.popCurrentPage()  // 기존 결과화면을 내림 
            })
            .disposed(by: disposeBag)
    }
    
    // TODO: 다음 배포버전에서 구현 예정 (식당 화면으로 전환)
//    private func configureRestaurantCheckButtonDidTap(by inputObserver: Observable<Void>) {
//    }
}

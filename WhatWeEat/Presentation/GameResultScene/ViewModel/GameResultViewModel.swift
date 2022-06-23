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
        let nextMenu: Observable<Menu?>
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
        coordinator.finish()  // TODO: 호출되는지 확인 필요
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let firstMenuAndPlayerCountAndPinNumber = configureFirstMenuAndPlayerCountAndPinNumber(with: input.invokedViewDidLoad)
//        configureRestaurantCheckButtonDidTap(with: input.restaurantCheckButtonDidTap)
        let nextMenu = configureNextMenuCheckButtonDidTap(with: input.nextMenuCheckButtonDidTap)
        configureGameRestartButtonDidTap(with: input.gameRestartButtonDidTap)

        let output = Output(
            firstMenuAndPlayerCountAndPinNumber: firstMenuAndPlayerCountAndPinNumber,
            nextMenu: nextMenu,
            shareButtonDidTap: input.shareButtonDidTap
        )

        return output
    }
    
    private func configureFirstMenuAndPlayerCountAndPinNumber(
        with inputObserver: Observable<Void>
    ) -> Observable<(Menu, Int, String?)> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(Menu, Int, String?)> in
                if let pinNumber = self.pinNumber {
                    return self.fetchTogetherGameResult(with: self.pinNumber)
                        .map { menusAndPlayerCount in
                            guard let firstMenu = menusAndPlayerCount.menus.first else {
                                return (Menu(name: "", imageURL: "", keywords: []), menusAndPlayerCount.playerCount, pinNumber)
                            }
                            
                            self.menus = menusAndPlayerCount.menus
                            
                            return (firstMenu, menusAndPlayerCount.playerCount, pinNumber)
                        }
                } else {
                    guard let soloGameResult = self.soloGameResult,
                          let firstMenu = soloGameResult.menus.first
                    else {
                        return Observable.just((Menu(name: "", imageURL: "", keywords: []), 1, nil))
                    }
                    
                    self.menus = soloGameResult.menus
                    
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
    
    private func configureNextMenuCheckButtonDidTap(with inputObserver: Observable<Void>) -> Observable<Menu?> {
        inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<Menu?> in
                self.currentMenuIndex += 1
                
                return Observable.just(self.menus[safe: self.currentMenuIndex])
            }
    }

    private func configureGameRestartButtonDidTap(with inputObserver: Observable<Void>) {
        if pinNumber == nil {
            // TODO: 화면 전환 - 함께메뉴 초기화면, GameCoordinator 메모리 해제
            // 그룹 정보 삭제는 서버에서 처리 (1일 후 삭제)
            coordinator.showInitialTogetherMenuPage()
            coordinator.finish()
        } else {
            // TODO: 화면 전환 - 혼밥메뉴 초기화면, GameCoordinator 메모리 해제
            coordinator.showInitialSoloMenuPage()
            coordinator.finish()
        }
    }
    
//    private func deleteGroup(pinNumber: String) -> Observable<Data> {
//        return NetworkProvider().request(api: WhatWeEatURL.DeleteGroupAPI(pinNumber: pinNumber))
//            .withUnretained(self)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { _ in
//                self.coordinator.showInitialTogetherMenuPage()
//            })
//            .disposed(by: disposeBag)
//    }
    
    // TODO: 화면전환 - 식당 (다음 배포버전에서 추가할 예정)
//    private func configureRestaurantCheckButtonDidTap(with inputObserver: Observable<Void>) {
//    }
}

import Foundation
import RxSwift

final class SharePinNumberPageViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
        let gameStartButtonDidTap: Observable<Void>
    }

    struct Output {
        let pinNumber: Observable<String>
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: MainTabBarCoordinator!
    private let pinNumberData: Observable<Data>
    private var pinNumber: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: MainTabBarCoordinator, pinNumberData: Observable<Data>) {
        self.coordinator = coordinator
        self.pinNumberData = pinNumberData
//        hideTabBar()
    }
    
    // MARK: - Methods
    private func hideTabBar() {
        guard let mainTabBarController = coordinator.navigationController?.viewControllers.first as? MainTabBarController else {
            return
        }
        
        mainTabBarController.hideTabBar()
    }
    
    func transform(_ input: Input) -> Output {
        let pinNumber = configurePINNumber()
        configureletGameStartButtonDidTap(by: input.gameStartButtonDidTap)
        
        let output = Output(
            pinNumber: pinNumber,
            backButtonDidTap: input.backButtonDidTap,
            shareButtonDidTap: input.shareButtonDidTap
        )
        
        return output
    }
    
    private func configurePINNumber() -> Observable<String> {
        pinNumberData.map { [weak self] in
            guard let pinNumberText = String(data: $0, encoding: .utf8) else {
                return ""
            }
            
            self?.pinNumber = pinNumberText
            
            return pinNumberText
        }
    }
    
    private func configureletGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.coordinator.showGamePage(with: self.pinNumber)
        })
        .disposed(by: disposeBag)
    }
}

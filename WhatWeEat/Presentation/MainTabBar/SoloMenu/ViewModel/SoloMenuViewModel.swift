import RxSwift
import UIKit

final class SoloMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let gameStartButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: MainTabBarCoordinator!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: MainTabBarCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configureletGameStartButtonDidTap(by: input.gameStartButtonDidTap)
    }
    
    private func configureletGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver.subscribe(onNext: { [weak self] _ in
            self?.coordinator.showGamePage()
        })
        .disposed(by: disposeBag)
    }
}

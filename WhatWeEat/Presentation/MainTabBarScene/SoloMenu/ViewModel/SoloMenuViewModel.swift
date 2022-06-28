import RxSwift
import UIKit

protocol GameStartWaitingViewModel { }

final class SoloMenuViewModel: GameStartWaitingViewModel {
    // MARK: - Nested Types
    struct Input {
        let gameStartButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: SoloMenuCoordinator!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: SoloMenuCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configureGameStartButtonDidTap(by: input.gameStartButtonDidTap)
    }
    
    private func configureGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
            self.coordinator.showGamePage()
        })
        .disposed(by: disposeBag)
    }
}

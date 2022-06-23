import RxSwift
import UIKit

final class EnterWithPinNumberViewModel: GameStartWaitingViewModel {
    // MARK: - Nested Types
    struct Input {
        let gameStartButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: TogetherMenuCoordinator!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: TogetherMenuCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configureGameStartButtonDidTap(by: input.gameStartButtonDidTap)
    }
    
    private func configureGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver.subscribe(onNext: { [weak self] _ in
            self?.coordinator.showGamePage()
        })
        .disposed(by: disposeBag)
    }
}

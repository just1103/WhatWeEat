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
    private let pinNumber: String
    
    // MARK: - Initializers
    init(coordinator: TogetherMenuCoordinator, pinNumber: String) {
        self.coordinator = coordinator
        self.pinNumber = pinNumber
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configureGameStartButtonDidTap(by: input.gameStartButtonDidTap)
    }
    
    private func configureGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver.subscribe(onNext: { [weak self] _ in
            self?.coordinator.showGamePage(with: self?.pinNumber)
        })
        .disposed(by: disposeBag)
    }
}

import Foundation
import RxSwift

final class NetworkErrorViewModel {
    // MARK: - Nested Types
    struct Input {
        let retryButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: CoordinatorProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input) {
        configureRetryButtonDidTap(by: input.retryButtonDidTap)
    }

    private func configureRetryButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, _) in
                if NetworkConnectionManager.shared.isCurrentlyConnected {
                    owner.coordinator.popCurrentPage()
                }
            })
            .disposed(by: disposeBag)
    }
}

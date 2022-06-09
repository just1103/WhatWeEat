import Foundation
import RxSwift

final class TogetherMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let makeGroupButtonDidTap: Observable<Void>
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
        configureMakeGroupButtonDidTapObservable(input.makeGroupButtonDidTap)
    }
    
    private func configureMakeGroupButtonDidTapObservable(_ inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let pinNumberObservable = NetworkProvider().request(api: CreateGroupAPI())
                self?.coordinator.showSharePinNumberPage(with: pinNumberObservable)
            })
            .disposed(by: disposeBag)
    }
}

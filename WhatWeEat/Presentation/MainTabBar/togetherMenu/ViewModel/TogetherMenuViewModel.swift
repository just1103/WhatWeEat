import Foundation
import RxSwift

final class TogetherMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let makeGroupButtonDidTap: Observable<Void>
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
        configureMakeGroupButtonDidTapObservable(input.makeGroupButtonDidTap)
    }
    
    private func configureMakeGroupButtonDidTapObservable(_ inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let pinNumberObservable = NetworkProvider().request(api: WhatWeEatURL.CreateGroupAPI())
                self.coordinator.showSharePinNumberPage(with: pinNumberObservable)
            })
            .disposed(by: disposeBag)
    }
}

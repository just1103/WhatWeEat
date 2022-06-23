import Foundation
import RxSwift

final class TogetherMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let makeGroupButtonDidTap: Observable<Void>
        let pinNumberButtonDidTap: Observable<Void>
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
        configurePinNumberButtonDidTapObservable(input.pinNumberButtonDidTap)
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
    
    // TODO: 화면전환 전에 Event가 여러번 전달되지 않을지 고려
    private func configurePinNumberButtonDidTapObservable(_ inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.coordinator.showEnterWithPinNumberPage()  // TODO: 입력한 pinNumber를 매개변수로 처리
            })
            .disposed(by: disposeBag)
    }
}

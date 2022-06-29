import Foundation
import RxSwift

final class TogetherMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let makeGroupButtonDidTap: Observable<Void>
        let pinNumberButtonDidTap: Observable<Void>
    }
    
    struct Output {
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
    func transform(_ input: Input) -> Output {
        checkNetworkConnection(by: input.invokedViewDidLoad)
        configureMakeGroupButtonDidTapObservable(input.makeGroupButtonDidTap)
//        configurePinNumberButtonDidTapObservable(input.pinNumberButtonDidTap)
        
        let output = Output(pinNumberButtonDidTap: input.pinNumberButtonDidTap)
        
        return output
    }
    
    func showEnterWithPinNumberPage(pinNumber: String) {
        coordinator.showEnterWithPinNumberPage(pinNumber: pinNumber)
    }
    
    private func checkNetworkConnection(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.checkNetworkConnection()
            })
            .disposed(by: disposeBag)
    }
    
    private func checkNetworkConnection() {
        if NetworkConnectionManager.shared.isCurrentlyConnected == false {
            coordinator.showNetworkErrorPage()
        }
    }
    
    private func configureMakeGroupButtonDidTapObservable(_ inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let pinNumberObservable = NetworkProvider().request(
                    api: WhatWeEatURL.CreateGroupAPI(token: AppDelegate.token)
                )
                self.coordinator.showSharePinNumberPage(with: pinNumberObservable)
            })
            .disposed(by: disposeBag)
    }
    
    // TODO: ViewController에서 처리해도 될지 고려
//    private func configurePinNumberButtonDidTapObservable(_ inputObserver: Observable<Void>) {
//        inputObserver
//            .withUnretained(self)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { _ in
//                self.coordinator.showEnterWithPinNumberPage(pinNumber: pinNumber)
//            })
//            .disposed(by: disposeBag)
//    }
}

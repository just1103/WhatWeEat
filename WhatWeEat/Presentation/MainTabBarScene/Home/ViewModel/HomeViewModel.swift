import UIKit
import RxSwift

final class HomeViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let invokedViewWillAppear: Observable<Void>
    }
    
    struct Output {
        let randomMenu: Observable<Menu>
    }
    
    // MARK: - Properties
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private weak var coordinator: HomeCoordinator!
    
    // MARK: - Initializers
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        checkNetworkConnection(by: input.invokedViewDidLoad)
        let randomMenu = configureItems(by: input.invokedViewWillAppear)
        
        let output = Output(randomMenu: randomMenu)
        
        return output
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
    
    private func configureItems(by inputObserver: Observable<Void>) -> Observable<Menu> {
        inputObserver
            .flatMap { [weak self] () -> Observable<Menu> in
            let randomMenuObservable = NetworkProvider().fetchData(
                api: WhatWeEatURL.RandomMenuAPI(),
                decodingType: Menu.self
            )
            self?.checkNetworkConnection()
            
            return randomMenuObservable
        }
    }
}

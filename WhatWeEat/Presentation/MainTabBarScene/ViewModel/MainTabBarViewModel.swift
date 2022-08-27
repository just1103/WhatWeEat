import Foundation
import RxSwift

final class MainTabBarViewModel {
    // MARK: - Nested Types
    struct Input {
        let rightBarButtonItemDidTap: Observable<Void>
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
        configureRightBarButtonItemDidTap(by: input.rightBarButtonItemDidTap)
    }
    
    private func configureRightBarButtonItemDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.coordinator.showSettingPage()
            })
            .disposed(by: disposeBag)
    }
}

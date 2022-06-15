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
        configureRightBarButtonItemDidTap(with: input.rightBarButtonItemDidTap)
    }
    
    private func configureRightBarButtonItemDidTap(with inputObserver: Observable<Void>) {
        inputObserver
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator.showSettingPage()
            })
            .disposed(by: disposeBag)
    }
}

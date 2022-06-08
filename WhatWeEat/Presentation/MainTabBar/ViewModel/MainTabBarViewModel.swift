import Foundation
import RxSwift

final class MainTabBarViewModel {
    struct Input {
        let rightBarButtonItemDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private let actions: MainTabBarViewModelAction!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(actions: MainTabBarViewModelAction) {
        self.actions = actions
    }
    
    func transform(_ input: Input) {
        configureRightBarButtonItemDidTap(with: input.rightBarButtonItemDidTap)
    }
    
    private func configureRightBarButtonItemDidTap(with inputObserver: Observable<Void>) {
        inputObserver
            .subscribe(onNext: { [weak self] _ in
                self?.actions.showSettingPage()
            })
            .disposed(by: disposeBag)
    }
}


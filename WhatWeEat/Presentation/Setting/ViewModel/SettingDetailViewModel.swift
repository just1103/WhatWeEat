import Foundation
import RxSwift

final class SettingDetailViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: SettingCoordinator!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configurebackButtonDidTapObservable(with: input.backButtonDidTap)
    }
    
    private func configurebackButtonDidTapObservable(with inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator.popCurrentPage()
            })
            .disposed(by: disposeBag)
    }
}

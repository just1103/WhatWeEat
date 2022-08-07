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
        configurebackButtonDidTapObservable(by: input.backButtonDidTap)
    }
    
    private func configurebackButtonDidTapObservable(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, _) in
                owner.coordinator.popCurrentPage()
            })
            .disposed(by: disposeBag)
    }
}

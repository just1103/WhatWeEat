import Foundation
import RxSwift

final class SettingDetailViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private let actions: SettingDetailViewModelAction!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(actions: SettingDetailViewModelAction) {
        self.actions = actions
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configurebackButtonDidTapObservable(with: input.backButtonDidTap)
    }
    
    private func configurebackButtonDidTapObservable(with inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.actions.popCurrentPage()
            })
            .disposed(by: disposeBag)
    }
}

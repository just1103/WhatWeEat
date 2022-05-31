import Foundation
import RxSwift

final class TogetherMenuViewModel {
    // MARK: - Nested Types
    struct Input {
        let makeGroupButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private var actions: TogetherMenuViewModelAction!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(actions: TogetherMenuViewModelAction) {
        self.actions = actions
    }
    
    // MARK: - Methods
    func transform(_ input: Input) {
        configureMakeGroupButtonDidTapObservable(input.makeGroupButtonDidTap)
    }
    
    private func configureMakeGroupButtonDidTapObservable(_ inputObserver: Observable<Void>) {
        inputObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let pinNumberObservable = NetworkProvider().request(api: CreateGroupAPI())
                self?.actions.showSharePinNumberPage(pinNumberObservable)
            })
            .disposed(by: disposeBag)
    }
}

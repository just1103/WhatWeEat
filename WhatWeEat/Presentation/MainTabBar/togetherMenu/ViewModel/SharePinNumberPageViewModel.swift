import Foundation
import RxSwift

final class SharePinNumberPageViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
    }

    struct Output {
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let output = Output(backButtonDidTap: input.backButtonDidTap,
                            shareButtonDidTap: input.shareButtonDidTap)
        
        return output
    }
}

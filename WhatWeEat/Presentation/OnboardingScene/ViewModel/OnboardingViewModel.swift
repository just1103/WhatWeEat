import Foundation
import RxSwift

final class OnboardingViewModel {
    // MARK: - Nested Types
    struct Input {
        let skipButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let skipButtonDidTap: Observable<Void>
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let output = Output(skipButtonDidTap: input.skipButtonDidTap)
        
        return output
    }
}

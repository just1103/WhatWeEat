import Foundation
import RxSwift

final class SharePinNumberPageViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
    }

    struct Output {
        let pinNumber: Observable<String>
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private let pinNumberData: Observable<Data>
    
    // MARK: - Initializers
    init(pinNumberData: Observable<Data>) {
        self.pinNumberData = pinNumberData
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let pinNumber = configurePINNumber()
        
        let output = Output(
            pinNumber: pinNumber,
            backButtonDidTap: input.backButtonDidTap,
            shareButtonDidTap: input.shareButtonDidTap
        )
        
        return output
    }
    
    private func configurePINNumber() -> Observable<String> {
        pinNumberData.map {
            guard let pinNumberText = String(data: $0, encoding: .utf8) else {
                return ""
            }
            
            return pinNumberText
        }
    }
}

import Foundation
import RxSwift

final class SharePinNumberPageViewModel {
    // MARK: - Nested Types
    struct Input {
        let backButtonDidTap: Observable<Void>
        let shareButtonDidTap: Observable<Void>
        let gameStartButtonDidTap: Observable<Void>  // together 화면 - userDefault의 핀넘버/게임상태 초기화
    }

    struct Output {
        let pinNumber: Observable<String>
        let shareButtonDidTap: Observable<Void>
    }
    
    // MARK: - Properties
    private weak var coordinator: TogetherMenuCoordinator!
    private let pinNumberData: Observable<Data>
    private var pinNumber: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: TogetherMenuCoordinator, pinNumberData: Observable<Data>) {
        self.coordinator = coordinator
        self.pinNumberData = pinNumberData
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let pinNumber = configurePINNumber()
        configureBackButtonDidTap(by: input.backButtonDidTap)
        configureGameStartButtonDidTap(by: input.gameStartButtonDidTap)
        
        let output = Output(
            pinNumber: pinNumber,
            shareButtonDidTap: input.shareButtonDidTap
        )
        
        return output
    }
    
    private func configurePINNumber() -> Observable<String> {
        pinNumberData.map { [weak self] in
            guard let pinNumberText = String(data: $0, encoding: .utf8) else {
                return ""
            }
            
            self?.pinNumber = pinNumberText
            
            return pinNumberText
        }
    }
    
    private func configureBackButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.coordinator.popCurrentPage()
        })
        .disposed(by: disposeBag)
    }
    
    private func configureGameStartButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.coordinator.showGamePage(with: self.pinNumber)
                UserDefaults.standard.set(false, forKey: "isTogetherGameSubmitted")
                UserDefaults.standard.set(self.pinNumber, forKey: "latestPinNumber")
        })
        .disposed(by: disposeBag)
    }
}

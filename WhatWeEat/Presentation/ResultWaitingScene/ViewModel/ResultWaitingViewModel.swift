import Foundation
import RxSwift

final class ResultWaitingViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let gameResultCheckButtonDidTap: Observable<Void>
        let gameRestartButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let pinNumberAndResultWaitingInformation: Observable<(String, Int, Bool, Bool)>
        let updatedSubmissionCount: Observable<Int>
        let updatedIsGameClosed: Observable<Bool>
    }
    
    // MARK: - Properties
    private weak var coordinator: GameCoordinator!
    private let pinNumber: String
    private var latestSubmissionCount: Int!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(coordinator: GameCoordinator, pinNumber: String) {
        self.coordinator = coordinator
        self.pinNumber = pinNumber
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let pinNumberAndResultWaitingInformation = configureInitialUI(by: input.invokedViewDidLoad)
        let updatedSubmissionCount = PublishSubject<Int>()
        let updatedIsGameClosed = PublishSubject<Bool>()

        configureUpdatedSubmissionCountAndIsGameClosed(
            by: input.invokedViewDidLoad,
            outputForSubmissionCount: updatedSubmissionCount,
            outputForIsGameClosed: updatedIsGameClosed
        )
        configureGameResultCheckButtonDidTap(by: input.gameResultCheckButtonDidTap)
        configureGameRestartButtonDidTap(by: input.gameRestartButtonDidTap)

        let output = Output(
            pinNumberAndResultWaitingInformation: pinNumberAndResultWaitingInformation,
            updatedSubmissionCount: updatedSubmissionCount.asObservable(),
            updatedIsGameClosed: updatedIsGameClosed.asObservable()
        )

        return output
    }
    
    private func configureInitialUI(by inputObserver: Observable<Void>) -> Observable<(String, Int, Bool, Bool)> {
        return inputObserver
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<(String, Int, Bool, Bool)> in
                return owner.fetchResultWaitingInformation(with: owner.pinNumber)
                    .map { resultWaiting in
                        let submissionCount = resultWaiting.submissionCount
                        let isHost = resultWaiting.isHost
                        let isGameClosed = resultWaiting.isGameClosed
                        
                        owner.latestSubmissionCount = submissionCount
                        
                        return (owner.pinNumber, submissionCount, isHost, isGameClosed)
                    }
            }
    }

    private func fetchResultWaitingInformation(with pinNumber: String) -> Observable<ResultWaiting> {
        let networkProvider = NetworkProvider()
        let observable = networkProvider.fetchData( // TODO: 토큰 입력
            api: WhatWeEatURL.GameResultWaitingAPI(pinNumber: pinNumber, token: AppDelegate.token),
            decodingType: ResultWaiting.self
        )
        return observable
    }
    
    // FIXME: inout처럼 쓰는 방법 밖에 없을까? (외부에 PublishSubject 타입의 output을 두는 방법)
    private func configureUpdatedSubmissionCountAndIsGameClosed(
        by inputObserver: Observable<Void>,
        outputForSubmissionCount: PublishSubject<Int>,
        outputForIsGameClosed: PublishSubject<Bool>
    ) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.setupTimerForUpdatedSubmissionCount(
                    outputForSubmissionCount: outputForSubmissionCount,
                    outputForIsGameClosed: outputForIsGameClosed
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTimerForUpdatedSubmissionCount(
        timeInterval: TimeInterval = 10,
        outputForSubmissionCount: PublishSubject<Int>,
        outputForIsGameClosed: PublishSubject<Bool>
    ) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.checkUpdatedSubmissionCountAndIsGameClosed(
                outputForSubmissionCount: outputForSubmissionCount,
                outputForIsGameClosed: outputForIsGameClosed
            )
        }
    }
    
    private func checkUpdatedSubmissionCountAndIsGameClosed(
        outputForSubmissionCount: PublishSubject<Int>,
        outputForIsGameClosed: PublishSubject<Bool>
    ) {
        fetchResultWaitingInformation(with: pinNumber)
            .withUnretained(self)
            .subscribe(onNext: { (owner, resultWaiting) in
                let submissionCount = resultWaiting.submissionCount
                let isGameClosed = resultWaiting.isGameClosed

                if submissionCount != owner.latestSubmissionCount {
                    outputForSubmissionCount.onNext(submissionCount)
                    owner.latestSubmissionCount = submissionCount
                }
                
                if isGameClosed {
                    outputForIsGameClosed.onNext(isGameClosed)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureGameResultCheckButtonDidTap(by inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.coordinator.showGameResultPage(with: owner.pinNumber, soloGameResult: nil)
                UserDefaults.standard.set(false, forKey: Text.isTogetherGameSubmittedKey)
                UserDefaults.standard.set(nil, forKey: Text.latestPinNumber)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureGameRestartButtonDidTap(by inputObserver: Observable<Void>) {
        return inputObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.requestGameSubmissionCancel(pinNumber: owner.pinNumber, token: AppDelegate.token)
                UserDefaults.standard.set(false, forKey: Text.isTogetherGameSubmittedKey)
                UserDefaults.standard.set(nil, forKey: Text.latestPinNumber)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestGameSubmissionCancel(pinNumber: String, token: String) {
        NetworkProvider().request(
            api: WhatWeEatURL.CancelSubmissionAPI(pinNumber: pinNumber, token: token)
        )
        .withUnretained(self)
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { (owner, _) in
            owner.coordinator.showInitialTogetherMenuPage()
            owner.coordinator.popCurrentPage()
        })
        .disposed(by: disposeBag)
    }
}

extension ResultWaitingViewModel {
    private enum Text {
        static let isTogetherGameSubmittedKey = "isTogetherGameSubmitted"
        static let latestPinNumber = "latestPinNumber"
    }
}

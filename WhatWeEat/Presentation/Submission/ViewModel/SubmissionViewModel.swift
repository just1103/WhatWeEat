import Foundation
import RxSwift

final class SubmissionViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
        let gameResultCheckButtonDidTap: Observable<Void>
        let gameRestartButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let pinNumberAndSubmissionCount: Observable<(String, Int)>
        let updatedSubmissionCount: Observable<Int>
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
        let pinNumberAndSubmissionCount = configurePinNumberAndSubmissionCount(with: input.invokedViewDidLoad)
        let updatedSubmissionCount = PublishSubject<Int>()

        configureUpdatedSubmissionCount(with: input.invokedViewDidLoad, output: updatedSubmissionCount)
        configureGameResultCheckButtonDidTap(with: input.gameResultCheckButtonDidTap)
        configureGameRestartButtonDidTap(with: input.gameRestartButtonDidTap)

        let ouput = Output(
            pinNumberAndSubmissionCount: pinNumberAndSubmissionCount,
            updatedSubmissionCount: updatedSubmissionCount
        )

        return ouput
    }
    
    private func configurePinNumberAndSubmissionCount(with inputObserver: Observable<Void>) -> Observable<(String, Int)> {
        return inputObserver
            .withUnretained(self)
            .flatMap { _ -> Observable<(String, Int)> in
                return self.fetchSubmissionCount(with: self.pinNumber)
                    .map { submissionCount in
                        return (self.pinNumber, submissionCount)
                    }
            }
    }

    private func fetchSubmissionCount(with pinNumber: String) -> Observable<Int> {
        let networkProvider = NetworkProvider()
        let observable = networkProvider.fetchData(
            api: WhatWeEatURL.SubmissionCountAPI(pinNumber: pinNumber),
            decodingType: Int.self  
        )
        return observable
    }
    
    // FIXME: 여기는 inout처럼 쓰는 방법 밖에 없을까? (외부에 PublishSubject 타입의 output을 두는 방법)
    private func configureUpdatedSubmissionCount(with inputObserver: Observable<Void>, output: PublishSubject<Int>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.setupTimerForUpdatedSubmissionCount(output: output)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTimerForUpdatedSubmissionCount(timeInterval: TimeInterval = 10, output: PublishSubject<Int>) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.checkUpdatedSubmissionCount(output: output)
        }
    }
    
    private func checkUpdatedSubmissionCount(output: PublishSubject<Int>) {
        fetchSubmissionCount(with: pinNumber)
            .subscribe(onNext: { [weak self] submissionCount in
                if submissionCount != self?.latestSubmissionCount {
                    output.onNext(submissionCount)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureGameResultCheckButtonDidTap(with inputObserver: Observable<Void>) {
        inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                // TODO: 화면전환 - 게임결과 화면
//                self.coordinator
            })
            .disposed(by: disposeBag)
    }
    
    private func configureGameRestartButtonDidTap(with inputObserver: Observable<Void>) {
        return inputObserver
            .withUnretained(self)
            .subscribe(onNext: { _ in
                // TODO: 화면전환 - 해당 탭 초기화면
//                self.coordinator
            })
            .disposed(by: disposeBag)
    }
}

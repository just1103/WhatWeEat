import UIKit
import RxSwift

final class HomeViewModel {
    // MARK: - Nested Types
    struct Input {
        let invokedViewDidLoad: Observable<Void>
    }
    
    struct Output {
        let randomMenu: Observable<Menu>
    }
    
    // MARK: - Properties
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let randomMenu = configureItems(by: input.invokedViewDidLoad)
        
        let output = Output(randomMenu: randomMenu)
        
        return output
    }
    
    private func configureItems(by inputObserver: Observable<Void>) -> Observable<Menu> {
        inputObserver.flatMap { () -> Observable<Menu> in
            let randomMenuObservable = NetworkProvider().fetchData(api: RandomMenuAPI(), decodingType: Menu.self) 
            return randomMenuObservable
        }
    }
}

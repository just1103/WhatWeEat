import UIKit
import RxCocoa

final class EnterWithPinNumberViewController: GameStartWaitingViewController, TabBarContentProtocol {
    // MARK: - Properties
    private var viewModel: EnterWithPinNumberViewModel!
    
    // MARK: - Initializers
    convenience init(viewModel: EnterWithPinNumberViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
}

// MARK: - Rx binding Methods
extension EnterWithPinNumberViewController {
    private func bind() {
        let input = EnterWithPinNumberViewModel.Input(gameStartButtonDidTap: gameStartButton.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}

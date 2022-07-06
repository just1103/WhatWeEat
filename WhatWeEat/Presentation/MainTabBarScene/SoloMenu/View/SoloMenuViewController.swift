import UIKit
import RxCocoa
import RxSwift

// ???: Solo메뉴, Together메뉴의 중복되는 게임대기화면을 상속으로 처리하여 중복코드 최소화 (다른 방법 고민)
final class SoloMenuViewController: GameStartWaitingViewController, TabBarContentProtocol {
    // MARK: - Properties
    private var viewModel: SoloMenuViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    
    // MARK: - Initializers
    convenience init(viewModel: SoloMenuViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        configureTabBar()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = Text.tabBarTitle
        tabBarItem.image = Content.tabBarImage
        tabBarItem.selectedImage = Content.tabBarSelectedImage
        tabBarItem.setTitleTextAttributes([.font: Design.tabBarTitleFont], for: .normal)
    }
}

// MARK: - Rx binding Methods
extension SoloMenuViewController {
    private func bind() {
        let input = SoloMenuViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            gameStartButtonDidTap: gameStartButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input)
    }
}

// MARK: - Namespaces
extension SoloMenuViewController {
    private enum Design {
        static let tabBarTitleFont: UIFont = .pretendard(family: .medium, size: 12)
    }
    
    private enum Content {
        static let tabBarImage = UIImage(systemName: "person")
        static let tabBarSelectedImage = UIImage(systemName: "person.fill")
        
    }
    
    private enum Text {
        static let tabBarTitle = "혼밥 메뉴 결정"
    }
}

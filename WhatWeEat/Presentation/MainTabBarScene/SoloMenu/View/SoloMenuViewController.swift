import UIKit
import RxCocoa

// ???: Solo메뉴, Together메뉴의 중복되는 게임대기화면을 상속으로 처리하여 중복코드 최소화 (다른 방법 고민)
final class SoloMenuViewController: GameStartWaitingViewController, TabBarContentProtocol {
    // MARK: - Properties
    private var viewModel: SoloMenuViewModel!
    
    // MARK: - Initializers
    convenience init(viewModel: SoloMenuViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        configureTabBar()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()  // ??? super.configureUI 아니여도 쓸수있음
        bind()
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = "혼밥 메뉴 결정"
        tabBarItem.image = UIImage(systemName: "person")
        tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
}

// MARK: - Rx binding Methods
extension SoloMenuViewController {
    private func bind() {
        let input = SoloMenuViewModel.Input(gameStartButtonDidTap: gameStartButton.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}

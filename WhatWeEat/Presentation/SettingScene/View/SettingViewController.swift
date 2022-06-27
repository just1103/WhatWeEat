import RxCocoa
import RxSwift
import UIKit

// TODO: 텍스트 위아래 여백+
// 설정 네비게이션바 색깔을 그레이로, 네비게이션 타이틀 텍스트컬러를 오렌지로 바꿔보기

final class SettingViewController: UIViewController {
    // MARK: - Nested Types
    enum SectionKind: Int, CaseIterable {
        case dislikedFood
        case ordinary 
        case version
    }
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var viewModel: SettingViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var viewModelOutput: SettingViewModel.Output?
    private var settingItems = [SettingItem]()
    
    // MARK: - Initializers
    convenience init(viewModel: SettingViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        let backButtonImage = UIImage(systemName: "arrow.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .mainOrange
        
        navigationItem.title = "설정"
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mainOrange,
            .font: UIFont.pretendard(family: .medium, size: 25),
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureTableView() {
        self.view.backgroundColor = .systemGray6
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6  // TODO: 더 밝은 회색으로, 화이트에 가까운 색으로 (같은 색이라도 면적이 넓으면 색깔이 더 어두워보임)
        tableView.register(cellType: VersionCell.self)
        tableView.register(cellType: SettingCell.self)
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
}

// MARK: - Rx Binding Methods
extension SettingViewController {
    private func bind() {
        guard let leftNavigationItem = navigationItem.leftBarButtonItem else { return }
        
        let input = SettingViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            backButtonDidTap: leftNavigationItem.rx.tap.asObservable(),
            settingItemDidSelect: tableView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureTableViewItems(with: output.tableViewItems)
        configureBackButtonDidTap(with: output.backButtonDidTap)
    }
    
    private func configureTableViewItems(with items: Observable<[SettingItem]>) {
        items
            .subscribe(onNext: { [weak self] items in
                self?.settingItems = items as [SettingItem]
            })
            .disposed(by: disposeBag)
    }
    
    private func configureBackButtonDidTap(with backButtonDidTap: Observable<Void>) {
        backButtonDidTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView DataSource
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionKind = SectionKind(rawValue: section) else { return 0 }
        switch sectionKind {
        case .dislikedFood:
            let dislikedFoodItems = settingItems.filter { $0.sectionKind == .dislikedFood }
            return dislikedFoodItems.count
        case .ordinary:
            let ordinarySettingItems = settingItems.filter { $0.sectionKind == .ordinary }
            return ordinarySettingItems.count
        case .version:
            let versionItems = settingItems.filter { $0.sectionKind == .version }
            return versionItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionKind = SectionKind(rawValue: indexPath.section) else { return UITableViewCell() }
        switch sectionKind {
        case .dislikedFood:
            let cell = tableView.dequeueReusableCell(of: SettingCell.self, for: indexPath)
            guard
                let dislikedFoodItems = settingItems.filter({ $0.sectionKind == .dislikedFood }) as? [SettingViewModel.OrdinarySettingItem]
            else {
                return UITableViewCell()
            }
            dislikedFoodItems.forEach { dislikedFoodItem in
                cell.apply(title: dislikedFoodItem.title)
            }

            return cell
        case .ordinary:
            let cell = tableView.dequeueReusableCell(of: SettingCell.self, for: indexPath)
            guard
                let ordinarySettingItems = settingItems.filter({ $0.sectionKind == .ordinary }) as? [SettingViewModel.OrdinarySettingItem]
            else {
                return UITableViewCell()
            }
            
            cell.apply(title: ordinarySettingItems[indexPath.row].title)

            return cell
        case .version:
            let cell = tableView.dequeueReusableCell(of: VersionCell.self, for: indexPath)
            let versionItems = settingItems.filter { $0.sectionKind == .version }
            guard let versionItem = versionItems.first as? SettingViewModel.VersionSettingItem else {
                return UITableViewCell()
            }
            cell.apply(title: versionItem.title, subtitle: versionItem.subtitle, buttonTitle: versionItem.buttonTitle)

            return cell
        }
    }
}

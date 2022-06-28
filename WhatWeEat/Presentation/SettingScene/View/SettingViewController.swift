import RxCocoa
import RxSwift
import UIKit

// TODO: 설정 네비게이션바 색깔 수정

final class SettingViewController: UIViewController {
    // MARK: - Nested Types
    enum SectionKind: Int, CaseIterable {
        case dislikedFood
        case common 
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
        let backButtonImage = Content.backButtonImage
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = Design.navagationLeftBarButtonTintColor
        
        navigationItem.title = Text.navigationTitle
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: Design.navigationTitleColor,
            .font: Design.navigationTitleFont,
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func configureTableView() {
        self.view.backgroundColor = Design.backgroundColor
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .backgroundGray
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
    
    private func configureTableViewItems(with outputObservable: Observable<[SettingItem]>) {
        outputObservable
            .withUnretained(self)
            .subscribe(onNext: { (self, items) in
                self.settingItems = items as [SettingItem]
            })
            .disposed(by: disposeBag)
    }
    
    private func configureBackButtonDidTap(with outputObservable: Observable<Void>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: false)
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
        case .common:
            let commonSettingItems = settingItems.filter { $0.sectionKind == .common }
            return commonSettingItems.count
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
                let dislikedFoodItems = settingItems.filter({ $0.sectionKind == .dislikedFood }) as? [SettingViewModel.CommonSettingItem]
            else {
                return UITableViewCell()
            }
            dislikedFoodItems.forEach { dislikedFoodItem in
                cell.apply(title: dislikedFoodItem.title)
            }

            return cell
        case .common:
            let cell = tableView.dequeueReusableCell(of: SettingCell.self, for: indexPath)
            guard
                let commonSettingItems = settingItems.filter({ $0.sectionKind == .common }) as? [SettingViewModel.CommonSettingItem]
            else {
                return UITableViewCell()
            }
            
            cell.apply(title: commonSettingItems[indexPath.row].title)

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

extension SettingViewController {
    private enum Design {
        static let navagationLeftBarButtonTintColor: UIColor = .black
        static let navigationTitleColor: UIColor = .black
        static let navigationTitleFont: UIFont = UIFont.pretendard(family: .medium, size: 25)
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Content {
        static let backButtonImage = UIImage(systemName: "arrow.backward")
    }
    
    private enum Text {
        static let navigationTitle = "설정"
    }
}

import RxCocoa
import RxSwift
import UIKit

final class TogetherMenuViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = Design.containerStackViewBackgroundColor
        stackView.directionalLayoutMargins = Design.containerStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let makeGroupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Design.makeGroupButtonBackgroundColor
        button.layer.cornerRadius = Design.makeGroupButtonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    private let makeGroupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Content.makeGroupImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Design.makeGroupImageViewTintColor
        return imageView
    }()
    private let makeGroupDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.makeGroupDescriptionLabelText
        label.font = Design.makeGroupDescriptionLabelFont
        label.textColor = Design.makeGroupDescriptionLabelTextColor
        return label
    }()
    private let makeGroupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.makeGroupTitleLabelText
        label.font = Design.makeGroupTitleLabelFont
        label.textColor = Design.makeGroupTitleLabelTextColor
        return label
    }()
    private let separatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.separatorLineViewBackgroundColor
        return view
    }()
    private let pinNumberButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Design.pinNumberButtonBackgroundColor
        button.layer.cornerRadius = Design.pinNumberButtonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    private let pinNumberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Content.pinNumberImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Design.pinNumberImageViewTintColor
        return imageView
    }()
    private let pinNumberDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.pinNumberDescriptionLabelText
        label.font = Design.pinNumberDescriptionLabelFont
        label.textColor = Design.pinNumberDescriptionLabelTextColor
        return label
    }()
    private let pinNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.pinNumberTitleLabelText
        label.font = Design.pinNumberTitleLabelFont
        label.textColor = Design.pinNumberTitleLabelTextColor
        return label
    }()
    
    private var viewModel: TogetherMenuViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    convenience init(viewModel: TogetherMenuViewModel) {
        self.init()
        self.viewModel = viewModel
        configureTabBar()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = Text.tabBarTitle
        tabBarItem.image = Content.tabBarImage
        tabBarItem.selectedImage = Content.tabBarSelectedImage
        tabBarItem.setTitleTextAttributes([.font: Design.tabBarTitleFont], for: .normal)
    }
    
    private func configureUI() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(makeGroupButton)
        containerStackView.addArrangedSubview(separatorLineView)
        containerStackView.addArrangedSubview(pinNumberButton)
        makeGroupButton.addSubview(makeGroupImageView)
        makeGroupButton.addSubview(makeGroupDescriptionLabel)
        makeGroupButton.addSubview(makeGroupTitleLabel)
        pinNumberButton.addSubview(pinNumberImageView)
        pinNumberButton.addSubview(pinNumberDescriptionLabel)
        pinNumberButton.addSubview(pinNumberTitleLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            makeGroupButton.heightAnchor.constraint(
                equalTo: containerStackView.heightAnchor,
                multiplier: Constraint.makeGroupButtonHeightAnchorMultiplier
            ),

            makeGroupTitleLabel.bottomAnchor.constraint(
                equalTo: makeGroupButton.bottomAnchor,
                constant: Constraint.makeGroupTitleLabelBottomAnchorConstant
            ),
            makeGroupTitleLabel.trailingAnchor.constraint(
                equalTo: makeGroupButton.trailingAnchor,
                constant: Constraint.makeGroupTitleLabelTrailingAnchorConstant
            ),
//            makeGroupDescriptionLabel.heightAnchor.constraint(equalTo: makeGroupButton.heightAnchor, multiplier: 0.1),
            makeGroupDescriptionLabel.bottomAnchor.constraint(
                equalTo: makeGroupTitleLabel.topAnchor,
                constant: Constraint.makeGroupDescriptionLabelBottomAnchorConstant
            ),
            makeGroupDescriptionLabel.trailingAnchor.constraint(equalTo: makeGroupTitleLabel.trailingAnchor),
            makeGroupImageView.heightAnchor.constraint(
                equalTo: makeGroupButton.heightAnchor,
                multiplier: Constraint.makeGroupImageViewHeightAnchorMultiplier
            ),
            makeGroupImageView.widthAnchor.constraint(equalTo: makeGroupImageView.heightAnchor),
            makeGroupImageView.bottomAnchor.constraint(
                equalTo: makeGroupDescriptionLabel.topAnchor,
                constant: Constraint.makeGroupImageViewBottomAnchorConstant
            ),
            makeGroupImageView.trailingAnchor.constraint(equalTo: makeGroupTitleLabel.trailingAnchor),
            
            separatorLineView.heightAnchor.constraint(
                equalToConstant: Constraint.separatorLineViewHeightAnchorConstant
            ),
            
            pinNumberButton.heightAnchor.constraint(
                equalTo: containerStackView.heightAnchor,
                multiplier: Constraint.pinNumberButtonHeightAnchorMultiplier
            ),

//            pinNumberTitleLabel.heightAnchor.constraint(equalTo: pinNumberButton.heightAnchor, multiplier: 0.3),
            pinNumberTitleLabel.bottomAnchor.constraint(
                equalTo: pinNumberButton.bottomAnchor,
                constant: Constraint.pinNumberTitleLabelBottomAnchorConstant
            ),
            pinNumberTitleLabel.leadingAnchor.constraint(
                equalTo: pinNumberButton.leadingAnchor,
                constant: Constraint.pinNumberTitleLabelLeadingAnchorConstant
            ),
//            pinNumberDescriptionLabel.heightAnchor.constraint(equalTo: pinNumberButton.heightAnchor, multiplier: 0.1),
            pinNumberDescriptionLabel.bottomAnchor.constraint(
                equalTo: pinNumberTitleLabel.topAnchor,
                constant: Constraint.pinNumberDescriptionLabelBottomAnchorConstant
            ),
            pinNumberDescriptionLabel.leadingAnchor.constraint(equalTo: pinNumberTitleLabel.leadingAnchor),
            pinNumberImageView.heightAnchor.constraint(
                equalTo: pinNumberButton.heightAnchor,
                multiplier: Constraint.pinNumberImageViewHeightAnchorMultiplier
            ),
            pinNumberImageView.widthAnchor.constraint(equalTo: pinNumberImageView.heightAnchor),
            pinNumberImageView.trailingAnchor.constraint(
                equalTo: pinNumberButton.trailingAnchor,
                constant: Constraint.pinNumberImageViewTrailingAnchorConstant
            ),
            pinNumberImageView.bottomAnchor.constraint(
                equalTo: pinNumberButton.bottomAnchor,
                constant: Constraint.pinNumberImageViewBottomAnchorConstant
            ),
        ])
    }
}

// MARK: - Rx Binding Methods
extension TogetherMenuViewController {
    private func bind() {
        let input = TogetherMenuViewModel.Input(
            makeGroupButtonDidTap: makeGroupButton.rx.tap.asObservable(),
            pinNumberButtonDidTap: pinNumberButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configurePinNumberInputAlert(with: output.pinNumberButtonDidTap)
    }
    
    private func configurePinNumberInputAlert(with buttonDidTap: Observable<Void>) {
        buttonDidTap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let cancelAction = UIAlertAction(title: Text.cancelActionTitle, style: .cancel)
                
                let alert = AlertFactory().createAlert(
                    style: .alert,
                    title: Text.alertTitle,
                    message: nil,
                    actions: cancelAction
                )
                alert.addTextField { textField in
                    textField.placeholder = Text.alertTextFieldPlaceholder
                }
                
                guard let textField = alert.textFields?[safe: 0] else { return }
                
                let okAction = UIAlertAction(title: Text.okActionTitle, style: .default) { _ in
                    self.validatePinNumber(textField.text ?? "")
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { isValid in
                            if isValid {
                                self.viewModel.showEnterWithPinNumberPage(pinNumber: textField.text ?? "")  // TODO: 여기서 호출하는게 적절한지 고려
                            } else {
                                alert.message = Text.errorAlertMessage
                                textField.text = nil
                                self.present(alert, animated: true)
                            }
                        })
                        .disposed(by: self.disposeBag)
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func validatePinNumber(_ pinNumber: String) -> Observable<Bool> {
        let isValid = NetworkProvider().fetchData(
            api: WhatWeEatURL.GroupValidationCheckAPI(pinNumber: pinNumber),
            decodingType: Bool.self
        )
        
        return isValid
    }
}

// MARK: - Namespaces
extension TogetherMenuViewController {
    private enum Design {
        static let containerStackViewBackgroundColor: UIColor = .white
        static let containerStackViewMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.05,
            leading: 20,
            bottom: UIScreen.main.bounds.height * 0.05,
            trailing: 20
        )
        static let makeGroupButtonBackgroundColor: UIColor = .mainOrange
        static let makeGroupButtonCornerRadius: CGFloat = 20
        static let makeGroupImageViewTintColor: UIColor = .white
        static let makeGroupDescriptionLabelFont: UIFont = .pretendard(family: .regular, size: 20)
        static let makeGroupDescriptionLabelTextColor: UIColor = .white
        static let makeGroupTitleLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let makeGroupTitleLabelTextColor: UIColor = .white
        static let separatorLineViewBackgroundColor: UIColor = .systemGray4
        static let pinNumberButtonBackgroundColor: UIColor = .systemGray6
        static let pinNumberButtonCornerRadius: CGFloat = 20
        static let pinNumberImageViewTintColor: UIColor = .black
        static let pinNumberDescriptionLabelFont: UIFont = .pretendard(family: .regular, size: 20)
        static let pinNumberDescriptionLabelTextColor: UIColor = .black
        static let pinNumberTitleLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let pinNumberTitleLabelTextColor: UIColor = .black
        static let tabBarTitleFont: UIFont = UIFont.pretendard(family: .medium, size: 12)
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Constraint {
        static let makeGroupButtonHeightAnchorMultiplier = 0.5
        static let makeGroupTitleLabelBottomAnchorConstant: CGFloat = -10
        static let makeGroupTitleLabelTrailingAnchorConstant: CGFloat = -10
        static let makeGroupDescriptionLabelBottomAnchorConstant: CGFloat = -8
        static let makeGroupImageViewHeightAnchorMultiplier = 0.5
        static let makeGroupImageViewBottomAnchorConstant: CGFloat = 10
        static let separatorLineViewHeightAnchorConstant: CGFloat = 1
        static let pinNumberButtonHeightAnchorMultiplier = 0.3
        static let pinNumberTitleLabelBottomAnchorConstant: CGFloat = -10
        static let pinNumberTitleLabelLeadingAnchorConstant: CGFloat = 10
        static let pinNumberDescriptionLabelBottomAnchorConstant: CGFloat = -8
        static let pinNumberImageViewHeightAnchorMultiplier = 0.3
        static let pinNumberImageViewTrailingAnchorConstant: CGFloat = -10
        static let pinNumberImageViewBottomAnchorConstant: CGFloat = -30
    }
    
    private enum Content {
        static let makeGroupImage = UIImage(systemName: "person.3.fill")
        static let pinNumberImage = UIImage(systemName: "123.rectangle")
        static let tabBarImage = UIImage(systemName: "person.3")
        static let tabBarSelectedImage = UIImage(systemName: "person.3.fill")
    }
    
    private enum Text {
        static let makeGroupDescriptionLabelText = "팀원들과 미니게임을 시작하려면"
        static let makeGroupTitleLabelText = "그룹 만들기"
        static let pinNumberDescriptionLabelText = "이미 생성된 그룹이 있다면"
        static let pinNumberTitleLabelText = "PIN으로 입장하기"
        static let tabBarTitle = "함께 메뉴 결정"
        static let cancelActionTitle = "취소"
        static let alertTitle = "PIN 번호를 입력해주세요"
        static let alertTextFieldPlaceholder = "PIN 번호를 입력해주세요"
        static let okActionTitle = "확인"
        static let errorAlertMessage = "잘못된 PIN 번호 입니다. 다시 입력해주세요."
    }
}

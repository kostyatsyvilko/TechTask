import UIKit
import SnapKit

final class AddPostViewController: BaseViewController {
    
    private enum Constants {
        static let textFieldPlaceholder = "Enter title"
        static let textViewFont: UIFont = .systemFont(ofSize: 14)
        static let defaultTextViewText = "Body"
        static let backImageName = "chevron.left"
        static let textContainerLineFragmentPadding: CGFloat = 0
        static let stackSpacing: CGFloat = 10
        static let navigationTitle = "Add new post"
        static let addButtonTitle = "Done"
        static let errorAlertTitle = "Error"
        static let yesAlertOption = "Yes"
        static let noAlertOption = "No"
        static let goBackWarningMessage = "You are trying to navigate back, but you entered some data and you will lost it. Are you sure you want to continue?"
        static let contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    }
    
    private var viewModel: AddPostViewModelProtocol
    
    private var isTextBodyNotEmpty: Bool {
        !(titleTextField.text ?? "").isEmpty && !bodyTextView.text.isEmpty
    }
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = Constants.textFieldPlaceholder
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = Constants.textViewFont
        textView.textContainer.lineFragmentPadding = Constants.textContainerLineFragmentPadding
        textView.text = Constants.defaultTextViewText
        
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, bodyTextView])
        
        stackView.axis = .vertical
        stackView.spacing = Constants.stackSpacing
        
        self.view.addSubview(stackView)
        
        return stackView
    }()
    
    init(viewModel: AddPostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        
        setupViewModelCallbacks()
    }
    
    private func configureNavigationBar() {
        self.title = Constants.navigationTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.addButtonTitle,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(onAddButtonTap))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.backImageName),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(onBackButtonTap))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func onAddButtonTap() {
        view.endEditing(true)
        let post = Post(title: titleTextField.text ?? "", body: bodyTextView.text)
        viewModel.save(post: post)
    }
    
    @objc private func onBackButtonTap() {
        showGoBackWarningAlert()
    }
    
    private func setupViewModelCallbacks() {
        viewModel.onReceiveError = { [weak self] error in
            self?.showErrorAlert(title: Constants.errorAlertTitle, message: error.localizedDescription)
        }
        
        viewModel.onSaveSuccess = { [weak self] in
            self?.viewModel.goBack()
        }
    }
    
    private func makeConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constants.contentInsets)
        }
    }
}

extension AddPostViewController {
    private func showGoBackWarningAlert() {
        let actionSheet = UIAlertController(
            title: Constants.errorAlertTitle,
            message: Constants.goBackWarningMessage,
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: Constants.yesAlertOption,
                                      style: .cancel) { [unowned self] _ in
            self.viewModel.goBack()
        }
    
        let noAction = UIAlertAction(title: Constants.noAlertOption, style: .default)
        
        actionSheet.addAction(noAction)
        actionSheet.addAction(yesAction)
        
        present(actionSheet, animated: true)
    }
}

extension AddPostViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = isTextBodyNotEmpty
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = isTextBodyNotEmpty
    }
}

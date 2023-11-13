import UIKit
import SnapKit

final class AddPostViewController: UIViewController {
    
    private enum Constants {
        static let textFieldPlaceholder = "Enter title"
        static let textViewFont: UIFont = .systemFont(ofSize: 14)
        static let defaultTextViewText = "Body"
        static let backImageName = "chevron.left"
        static let textContainerLineFragmentPadding: CGFloat = 0
        static let stackSpacing: CGFloat = 10
        static let navigationTitle = "Add new post"
        static let addButtonName = "plus"
        static let errorAlertTitle = "Error"
        static let okAlerOption = "Ok"
        static let yesAlertOption = "Yes"
        static let noAlertOption = "No"
        static let goBackWarningMessage = "You are trying to navigate back, but you entered some data and you will lost it. Are you sure you want to continue?"
        static let contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        
    }
    
    var viewModel: AddPostViewModel?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        configureNavigationBar()
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        self.title = Constants.navigationTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.addButtonName),
                                                                 style: .plain,
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
        do {
            try viewModel?.save(post: post)
            viewModel?.goBack()
        } catch AddPostViewModelError.postExists(let message) {
            showErrorAlert(message: message)
        } catch let error {
            showErrorAlert(message: error.localizedDescription)
        }
    }
    
    @objc private func onBackButtonTap() {
        showGoBackWarningAlert()
    }
    
    private func makeConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constants.contentInsets)
        }
    }
}

extension AddPostViewController {
    private func showErrorAlert(message: String) {
        let actionSheet = UIAlertController(
            title: Constants.errorAlertTitle,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.okAlerOption, style: .default)
    
        actionSheet.addAction(okAction)
        
        present(actionSheet, animated: true)
    }
    
    private func showGoBackWarningAlert() {
        let actionSheet = UIAlertController(
            title: Constants.errorAlertTitle,
            message: Constants.goBackWarningMessage,
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: Constants.yesAlertOption,
                                      style: .cancel) { [unowned self] _ in
            self.viewModel?.goBack()
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

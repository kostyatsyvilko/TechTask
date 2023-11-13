import UIKit
import SnapKit

final class PostListViewController: BaseViewController {
    
    private enum Constants {
        static let navigationTitle = "Posts"
        static let addButtonName = "plus"
        static let alertTitle = "Are you sure you want to delete?"
        static let alertDeleteOption = "Yes"
        static let alertCancelOption = "No"
        static let errorAlertTitle = "Error"
    }
    
    var viewModel: PostListViewModelProtocol?
    
    private lazy var postTableView: PostTableView = {
        let tableView = PostTableView()
        tableView.delegate = self
        view.addSubview(tableView)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        makeConstraints()
        
        setupViewModelCallbacks()
        
        viewModel?.startObserving()
        Task {
            await viewModel?.loadLocalPosts()
            await viewModel?.loadRemotePosts()
        }
    }
    
    @objc private func onPlusButtonTap() {
        viewModel?.goToAddPost()
    }
    
    private func setupViewModelCallbacks() {
        viewModel?.onReceivePosts = { [weak self] posts in
            self?.postTableView.addItems(posts: posts, animate: true)
        }
        
        viewModel?.onPostChange = { [weak self] result in
            guard let self else { return }
            self.postTableView.addItems(posts: result.value, animate: true)
        }
        
        viewModel?.onReceiveError = { [weak self] error in
            self?.showErrorAlert(title: Constants.errorAlertTitle, message: error.localizedDescription)
        }
    }
    
    private func configureNavigationBar() {
        self.title = Constants.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.addButtonName),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(onPlusButtonTap))
    }
    
    private func makeConstraints() {
        postTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PostListViewController: PostTableViewDelegate {
    func onPostDelete(post: Post) {
        viewModel?.delete(post: post)
    }
    
    func onPostLongPressed(post: Post) {
        showDeleteAler(for: post)
    }
    
    private func showDeleteAler(for post: Post) {
        let actionSheet = UIAlertController(
            title: Constants.alertTitle,
            message: nil,
            preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: Constants.alertDeleteOption,
                                         style: .destructive) { [unowned self] _ in
            viewModel?.delete(post: post)
        }
        
        let cancelAction = UIAlertAction(title: Constants.alertCancelOption, style: .cancel)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

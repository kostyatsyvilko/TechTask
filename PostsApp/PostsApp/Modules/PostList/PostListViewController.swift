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
    
    private var viewModel: PostListViewModelProtocol
    
    private lazy var postTableView: PostTableView = {
        let tableView = PostTableView()
        tableView.delegate = self
        view.addSubview(tableView)
        
        return tableView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        self.view.addSubview(view)
        return view
    }()
    
    init(viewModel: PostListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        makeConstraints()
        
        setupViewModelCallbacks()
        
        loadingView.startAnimating()
        
        onViewDidLoad()
    }
    
    @objc private func onPlusButtonTap() {
        viewModel.goToAddPost()
    }
    
    private func onViewDidLoad() {
        viewModel.startObserving()
        Task {
            await viewModel.loadPosts()
        }
    }
    
    private func setupViewModelCallbacks() {
        viewModel.onReceivePosts = { [weak self] posts in
            if posts.count > 0 {
                self?.loadingView.stopAnimating()
            }
            self?.postTableView.addItems(posts: posts, animate: true)
        }
        
        viewModel.onPostChange = { [weak self] result in
            guard let self else { return }
            loadingView.stopAnimating()
            self.postTableView.addItems(posts: result.value, animate: true)
        }
        
        viewModel.onReceiveError = { [weak self] error in
            self?.showErrorAlert(title: Constants.errorAlertTitle, message: error.localizedDescription)
        }
        
        viewModel.onRemotePostsLoadingFinished = { [weak self] in
            self?.loadingView.stopAnimating()
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
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension PostListViewController: PostTableViewDelegate {
    func onPostDelete(post: Post) {
        viewModel.delete(post: post)
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
            viewModel.delete(post: post)
        }
        
        let cancelAction = UIAlertAction(title: Constants.alertCancelOption, style: .cancel)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

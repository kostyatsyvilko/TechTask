import UIKit
import SnapKit

final class PostListViewController: UIViewController {
    
    private enum Constants {
        static var navigationTitle = "Posts"
        static var addButtonName = "plus"
    }
    
    var viewModel: PostListViewModelProtocol?
    
    private lazy var postTableView: PostTableView = {
        let tableView = PostTableView()
        
        view.addSubview(tableView)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        makeConstraints()
        
        setupViewModelCallbacks()
        
        Task {
            await viewModel?.loadLocalPosts()
            await viewModel?.loadRemotePosts()
        }
    }
    
    @objc private func onPlusButtonTap() {
        
        let random = Int.random(in: 1...200)
        let post = Post(title: "\(random)", body: "Body")
        postTableView.appendItems(posts: [post])
    }
    
    private func setupViewModelCallbacks() {
        viewModel?.onReceivePosts = { [weak self] posts in
            self?.postTableView.appendItems(posts: posts, animate: false)
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

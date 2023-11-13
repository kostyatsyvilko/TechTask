import UIKit

protocol PostTableViewDelegate: AnyObject {
    func onPostLongPressed(post: Post)
    func onPostDelete(post: Post)
}

final class PostTableView: UIView {
    
    private enum Constants {
        static let postCellReuseIdentifier = "postCell"
        static let deleteIconName = "trash"
    }
    
    private enum PostsTableViewSection: Hashable {
        case main
    }
    
    weak var delegate: PostTableViewDelegate?
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: Constants.postCellReuseIdentifier)
        tableView.delegate = self
        
        self.addSubview(tableView)
        
        return tableView
    }()
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<PostsTableViewSection, Post> = {
        let dataSource = UITableViewDiffableDataSource<PostsTableViewSection, Post>(tableView: postsTableView) { tableView, _, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellReuseIdentifier) as? PostTableViewCell else {
                return nil
            }
            cell.configure(title: model.title, body: model.body)
            return cell
        }
        
        return dataSource
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        setupLongGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeLongGestureRecognizer()
    }
    
    func addItems(posts: [Post], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<PostsTableViewSection, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts)
        
        tableViewDataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func makeConstraints() {
        postsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupLongGestureRecognizer() {
        if longPressGestureRecognizer == nil {
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
            postsTableView.addGestureRecognizer(longPressGestureRecognizer!)
        }
    }
    
    private func removeLongGestureRecognizer() {
        guard let longPressGestureRecognizer else {
           return
        }
        postsTableView.removeGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: postsTableView)
            guard let indexPath = postsTableView.indexPathForRow(at: touchPoint) else {
                return
            }
            guard let post = tableViewDataSource.itemIdentifier(for: indexPath) else {
                return
            }
            
            delegate?.onPostLongPressed(post: post)
        }
    }
}

extension PostTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let post = tableViewDataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            self?.delegate?.onPostDelete(post: post)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: Constants.deleteIconName)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



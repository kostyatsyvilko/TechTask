import UIKit

class PostTableView: UIView {
    
    private enum Constants {
        static var postCellReuseIdentifier = "postCell"
    }
    
    private enum PostsTableViewSection: Hashable {
        case main
    }
    
    private var snapshot = NSDiffableDataSourceSnapshot<PostsTableViewSection, Post>()
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: Constants.postCellReuseIdentifier)
        
        self.addSubview(tableView)
        
        return tableView
    }()
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<PostsTableViewSection, Post> = {
        let dataSource = UITableViewDiffableDataSource<PostsTableViewSection, Post>(tableView: postsTableView) { tableView, _, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellReuseIdentifier) as? PostTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: model.title, body: model.body)
            return cell
        }
        
        return dataSource
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}



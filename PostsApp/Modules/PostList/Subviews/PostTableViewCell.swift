import UIKit
import SnapKit

final class PostTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let contentStackSpacing: CGFloat = 10
        static let contentStackInsets: CGFloat = 10
        static let textNumberOfLines = 0
        static let titleFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
        static let bodyFont: UIFont = .systemFont(ofSize: 14)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.textNumberOfLines
        label.font = Constants.titleFont
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.textNumberOfLines
        label.font = Constants.bodyFont
        
        return label
    }()
    
    private lazy var contentHorizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        
        stack.axis = .vertical
        stack.spacing = Constants.contentStackSpacing
        stack.distribution = .fill
        
        self.addSubview(stack)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
    
    private func makeConstraints() {
        contentHorizontalStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(Constants.contentStackInsets)
        }
    }
}

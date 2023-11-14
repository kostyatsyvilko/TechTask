import Foundation

enum AddPostViewModelError: Error, LocalizedError {
    case postExists(message: String)
    
    var errorDescription: String? {
        switch self {
        case .postExists(let message):
            return message
        }
    }
}

protocol AddPostViewModelProtocol {
    var onReceiveError: ((Error) -> Void)? { get set }
    var onSaveSuccess: (() -> Void)? { get set }
    
    func save(post: Post)
    
    func goBack()
}

final class AddPostViewModel: AddPostViewModelProtocol {
    
    private enum Constants {
        static let postExistsMessage = "There is already post with the same title"
    }
    
    private let localPostsRepository: PostLocalRepositoryProtocol
    private let coordinator: AppCoordinator
    
    var onReceiveError: ((Error) -> Void)?
    var onSaveSuccess: (() -> Void)?
    
    init(localPostsRepository: PostLocalRepositoryProtocol,
         coordinator: AppCoordinator) {
        self.localPostsRepository = localPostsRepository
        self.coordinator = coordinator
    }
    
    func save(post: Post) {
        if localPostsRepository.exists(with: post.title) {
            onReceiveError?(AddPostViewModelError.postExists(message: Constants.postExistsMessage))
            return
        }
        
        do {
            try localPostsRepository.save(post: post)
            onSaveSuccess?()
        } catch let error {
            onReceiveError?(error)
        }
    }
}

extension AddPostViewModel {
    func goBack() {
        coordinator.goBack()
    }
}

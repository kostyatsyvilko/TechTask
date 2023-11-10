import Foundation

enum AddPostViewModelError: Error {
    case postExists(message: String)
}

protocol AddPostViewModelProtocol {
    func save(post: Post) throws
    
    func goBack()
}

final class AddPostViewModel: AddPostViewModelProtocol {
    
    private enum Constants {
        static let postExistsMessage = "There is already post with the same title"
    }
    
    private let localPostsRepository: PostsLocalRepositoryProtocol
    private let coordinator: AppCoordinator
    
    init(localPostsRepository: PostsLocalRepositoryProtocol,
         coordinator: AppCoordinator) {
        self.localPostsRepository = localPostsRepository
        self.coordinator = coordinator
    }
    
    func save(post: Post) throws {
        if localPostsRepository.exists(with: post.title) {
            throw AddPostViewModelError.postExists(message: Constants.postExistsMessage)
        }
        
        localPostsRepository.save(post: post)
    }
}

extension AddPostViewModel {
    func goBack() {
        coordinator.goBack()
    }
}

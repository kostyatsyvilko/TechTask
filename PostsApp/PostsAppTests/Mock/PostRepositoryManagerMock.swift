import Foundation
@testable import PostsApp

final class PostRepositoryManagerMock: PostRepositoryManagerProtocol {
    
    
    private var postDatabaseObserver: PostDatabaseObserver
    private var posts: [Post] = []
    
    init(postDatabaseObserver: PostDatabaseObserver = PostDatabaseObserverMock()) {
        self.postDatabaseObserver = postDatabaseObserver
    }
    
    func loadRemotePosts() async -> PostsApp.PostsResultType {
        let posts = [
            Post(title: "TitleRemote1", body: "Body"),
            Post(title: "TitleRemote2", body: "Body"),
            Post(title: "TitleRemote3", body: "Body")
        ]
        
        self.posts += posts
        callObserverOnChange()
        return .success(posts)
    }
    
    func loadLocalPosts() -> PostsApp.PostsResultType {
        return .success(posts)
    }
    
    func saveLocal(post: PostsApp.Post) throws {
        posts.append(post)
        callObserverOnChange()
    }
    
    func deleteLocal(post: PostsApp.Post) throws {
        posts.removeAll { $0.title == post.title }
        callObserverOnChange()
    }
    
    private func callObserverOnChange() {
        let observerResult = ObserverChangeResult(type: .insert, value: self.posts)
        postDatabaseObserver.onChange?(observerResult)
    }
    
}

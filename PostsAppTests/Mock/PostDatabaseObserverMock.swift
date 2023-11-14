import Foundation
@testable import PostsApp

final class PostDatabaseObserverMock: PostDatabaseObserver {
    var onChange: ((PostsApp.ObserverChangeResult<[PostsApp.Post]>) -> Void)?
    
    func startObserving() throws {
        
    }
}

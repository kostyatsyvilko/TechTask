import XCTest
@testable import PostsApp

final class PostRepositoryManagerTests: XCTestCase {
    
    var repositoryManager: PostRepositoryManagerProtocol!

    override func setUpWithError() throws {
        let remoteRepository = PostRemoteRepositoryMock()
        let localRepository = PostLocalRepositoryMock()
        repositoryManager = PostRepositoryManager(localRepository: localRepository,
                                                  remoteRepository: remoteRepository)
    }

    override func tearDownWithError() throws {
        repositoryManager = nil
    }

    func testLoadPosts() async throws {
        // Given
        
        // When
        _ = await repositoryManager.loadRemotePosts()
        let result = repositoryManager.loadLocalPosts()
        
        // Then
        switch result {
        case .success(let posts):
            XCTAssertTrue(!posts.isEmpty)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testSaveLocal() throws {
        // Given
        let title = "LocalTitle"
        let post = Post(title: title, body: "Body")
        
        // When
        try repositoryManager.saveLocal(post: post)
        let result = repositoryManager.loadLocalPosts()
        
        // Then
        switch result {
        case .success(let posts):
            let isContains = posts.contains { $0.title == title }
            XCTAssertTrue(isContains)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testDeleteLocal() throws {
        // Given
        let titleToDelete = "LocalTitleToDelte"
        let post = Post(title: titleToDelete, body: "Body")
        
        // When
        try repositoryManager.saveLocal(post: post)
        try repositoryManager.deleteLocal(post: post)
        
        let result = repositoryManager.loadLocalPosts()
        
        // Then
        switch result {
        case .success(let posts):
            let isContains = posts.contains { $0.title == titleToDelete }
            XCTAssertFalse(isContains)
        case .failure(_):
            XCTFail()
        }
    }

}

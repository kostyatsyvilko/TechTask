import XCTest
@testable import PostsApp

final class PostListViewModelTests: XCTestCase {
    
    var viewModel: PostListViewModelProtocol!

    override func setUpWithError() throws {
        let databaseObserver = PostDatabaseObserverMock()
        let repositoryManager = PostRepositoryManagerMock(postDatabaseObserver: databaseObserver)
        let coordinator = AppCoordinator(navigationController: UINavigationController(),
                                         coreDataConfigurator: CoreDataConfigurationMock())
        viewModel = PostListViewModel(postsRepositoryManager: repositoryManager,
                                      postDatabaseObserver: databaseObserver,
                                      coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        
    }

    func testOnReceiveEmptyPosts() throws {
        let exp = expectation(description: "Receive posts")
        
        // When
        Task {
            await viewModel.loadPosts()
        }
        
        viewModel.onReceivePosts = { posts in
            // Then
            XCTAssertTrue(posts.isEmpty)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testListenOnDatabaseObserverChangeAfterSavingRemotePosts() async throws {
        let exp = expectation(description: "Receive posts")
        
        viewModel.onPostChange = { result in
            XCTAssertTrue(!result.value.isEmpty)
            exp.fulfill()
        }
        viewModel.startObserving()
        
        await viewModel.loadPosts()
        
        await fulfillment(of: [exp], timeout: 1)
    }
}

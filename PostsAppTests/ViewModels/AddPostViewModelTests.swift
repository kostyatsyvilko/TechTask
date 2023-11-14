import XCTest
@testable import PostsApp

final class AddPostViewModelTests: XCTestCase {
    
    var viewModel: AddPostViewModelProtocol!

    override func setUpWithError() throws {
        let coordinator = AppCoordinator(navigationController: UINavigationController(),
                                         coreDataConfigurator: CoreDataConfigurationMock())
        let localRepository = PostLocalRepositoryMock()
        viewModel = AddPostViewModel(localPostsRepository: localRepository, coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testSaveWithSuccess() throws {
        let exp = expectation(description: "Save success")
        
        let post = Post(title: "TestSaveSuccess", body: "Body")
        viewModel.onSaveSuccess = {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        
        viewModel.save(post: post)
        
        waitForExpectations(timeout: 1)
    }
    
    func testSaveWithFailure() throws {
        let exp = expectation(description: "Save failure")
        
        let post = Post(title: "TestSaveFailure", body: "Body")
        
        viewModel.onReceiveError = { _ in
            XCTAssertTrue(true)
            exp.fulfill()
        }
        
        viewModel.save(post: post)
        viewModel.save(post: post)
        
        waitForExpectations(timeout: 1)
    }

}

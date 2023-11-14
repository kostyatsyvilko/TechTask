import XCTest
@testable import PostsApp

final class PostRepositoryTests: XCTestCase {
    
    var postRepository: PostRepository!

    override func setUpWithError() throws {
        let apiManager = ApiManagerMock()
        postRepository = PostRepository(apiManager: apiManager)
    }

    override func tearDownWithError() throws {
        postRepository = nil
    }

    func testReceiveDataWithSuccess() async throws {
        // Given
        let request = PostsRequest()
        
        // When
        let result = await postRepository.send(request)
        
        // Then
        switch result {
        case .success(let posts):
            XCTAssertTrue(!posts.isEmpty)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testReceiveDataWithError() async throws {
        // Given
        let request = ApiRequestMock()
        
        // When
        let result = await postRepository.send(request)
        
        // Then
        switch result {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertNotNil(error as? ApiError)
        }
    }
}

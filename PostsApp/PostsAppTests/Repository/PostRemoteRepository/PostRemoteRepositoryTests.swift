import XCTest
@testable import PostsApp

final class PostRemoteRepositoryTests: XCTestCase {
    
    var remoteRepository: PostRemoteRepositoryProtocol!

    override func setUpWithError() throws {
        let apiClient = PostRepositoryMock()
        remoteRepository = PostRemoteRepository(apiClient: apiClient)
    }

    override func tearDownWithError() throws {
        remoteRepository = nil
    }

    func testRetrieveDataWithSuccess() async throws {
        // Given
        
        // Then
        let result = await remoteRepository.loadPosts()
        
        // When
        switch result {
        case .success(let posts):
            XCTAssertTrue(!posts.isEmpty)
        case .failure(_):
            XCTFail()
        }
    }
}

import XCTest
@testable import PostsApp

final class PostLocalRepositoryTests: XCTestCase {
    
    var localRepository: PostLocalRepositoryProtocol!

    override func setUpWithError() throws {
        let coreDataManager = CoreDataPostManagerMock()
        localRepository = PostLocalRepository(coreDataManager: coreDataManager)
    }

    override func tearDownWithError() throws {
        localRepository = nil
    }

    func testSave() throws {
        // Given
        let post = Post(title: "Title1", body: "Body1")
        
        // When
        try localRepository.save(post: post)
        
        let result = localRepository.loadPosts()
        
        // Then
        switch result {
        case .success(let posts):
            let isContains = posts.contains { $0.title == "Title1" }
            XCTAssertTrue(isContains)
        case .failure(_):
            break
        }
    }
    
    func testDelete() throws {
        // Given
        let titleToDelete = "TitleToDelete"
        let post = Post(title: titleToDelete, body: "Body")
        
        // When
        try localRepository.save(post: post)
        try localRepository.delete(post: post)
        let result = localRepository.loadPosts()
        
        // Then
        switch result {
        case .success(let posts):
            let isContains = posts.contains { $0.title == titleToDelete }
            XCTAssertFalse(isContains)
        case .failure(_):
            break
        }
    }
    
    func testExist() throws {
        // Given
        let post = Post(title: "ExistTitle", body: "Body")
        
        // When
        try localRepository.save(post: post)
        let isCorrectTitleExist = localRepository.exists(with: post.title)
        let isIncorrectTitleExists = localRepository.exists(with: "IncorrectTitle")
        
        // Then
        XCTAssertTrue(isCorrectTitleExist)
        XCTAssertFalse(isIncorrectTitleExists)
    }
}

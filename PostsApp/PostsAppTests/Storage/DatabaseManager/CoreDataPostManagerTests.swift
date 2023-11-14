import XCTest
@testable import PostsApp

final class CoreDataPostManagerTests: XCTestCase {
    
    var databaseManager: CoreDataPostManagerProtocol!

    override func setUpWithError() throws {
        let configurator = CoreDataConfigurationMock()
        databaseManager = CoreDataPostManager(coreDataConfigurator: configurator)
    }

    override func tearDownWithError() throws {
        databaseManager = nil
    }

    func testSave() throws {
        // Given
        let post = Post(title: "Title1", body: "Body")
        
        // When
        try databaseManager.save(post: post)
        let posts = try databaseManager.fetch(predicate: nil)
        
        // Then
        let isContains = posts.contains { $0.title == post.title }
        XCTAssertTrue(isContains)
    }
    
    func testDelete() throws {
        // Given
        let titleToDelete = "TitleToDelete"
        let post = Post(title: titleToDelete, body: "Body")
        
        // When
        try databaseManager.save(post: post)
        try databaseManager.delete(for: titleToDelete)
        
        let posts = try databaseManager.fetch(predicate: nil)
        
        // Then
        let isContains = posts.contains { $0.title == titleToDelete }
        XCTAssertFalse(isContains)
    }
    
    func testExists() throws {
        // Given
        let titleToCheckExistence = "TitleExistence"
        let post = Post(title: titleToCheckExistence, body: "Body")
        
        // When
        try databaseManager.save(post: post)
        
        // Then
        let isCorrectTitleExist = try databaseManager.exists(with: titleToCheckExistence)
        let isIncorrectTitleExist = try databaseManager.exists(with: "IncorrectTitle")
        
        XCTAssertTrue(isCorrectTitleExist)
        XCTAssertFalse(isIncorrectTitleExist)
    }

}

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appWindow = UIWindow(windowScene: windowScene)
        let apiManager = UrlSessionManager()
        let apiClient = JsonPlaceholderClient(apiManager: apiManager)
        let remoteRepository = PostsRemoteRepository(apiClient: apiClient)
        let configuration = CoreDataConfigurator(dataModelName: DBConstants.coreDataModelName)
        let db = CoreDataManager(coreDataConfigurator: configuration)
        let localRepository = PostsLocalRepository(databaseManager: db)
        let repository = PostsRepositoryManager(localRepository: localRepository, remoteRepository: remoteRepository)
        
        let databaseObserver = CoreDataPostObserverConfigurator(coreDataConfigurator: configuration).configure()
        let postDatabaseObserver = PostDatabaseObserver(databaseObserver: databaseObserver)

        let viewModel = PostListViewModel(postsRepositoryManager: repository, postDatabaseObserver: postDatabaseObserver)
        let rootController = PostListViewController()
        rootController.viewModel = viewModel
        
        appWindow.rootViewController = UINavigationController(rootViewController: rootController)
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }
}


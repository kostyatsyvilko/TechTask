import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appWindow = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        
        let configurator = CoreDataConfiguratorFactory.create()
        let coordinator = AppCoordinator(navigationController: navigationController,
                                         coreDataConfigurator: configurator)
        coordinator.start()
        
        appWindow.rootViewController = navigationController
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }
}


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let appWindow = UIWindow(windowScene: windowScene)
        let rootController = PostListViewController()
        
        appWindow.rootViewController = UINavigationController(rootViewController: rootController)
        appWindow.makeKeyAndVisible()
        
        window = appWindow
    }
}


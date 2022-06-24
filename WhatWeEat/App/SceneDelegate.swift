import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .white
        window?.rootViewController = navigationController
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
    }
}

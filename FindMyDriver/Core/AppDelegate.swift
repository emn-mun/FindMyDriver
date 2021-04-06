import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = UINavigationController()
        let router = FindDriverRouter(rootViewController: rootViewController)
        router.showFindDriverViewController()
      
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        return true
    }

}

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureWindow()
        return true
    }
    
    private func configureWindow() {
        window = UIWindow()
        window?.rootViewController = HeadphonesPreparationViewController.instantiate { coder in
            return HeadphonesPreparationViewController(coder: coder, any: "")
        }
        window?.makeKeyAndVisible()
    }
}


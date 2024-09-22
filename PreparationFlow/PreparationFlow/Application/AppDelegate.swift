import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var preparationFlow: PreparationFlow!
    private lazy var microphonePermissionManager = MicrophonePermissionManager()
    private lazy var headphonesConnectionManager: HeadphonesConnectionManageable = HeadphonesConnectionManager()
    private lazy var systemVolumeManager: SystemVolumeManageable = SystemVolumeManager()
    private lazy var loudnessManager: LoudnessManageable = LoudnessManager(
        isMicrophonePermissionAllowed: microphonePermissionManager.isPermissionAllowed
    )
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let navigationController = UINavigationController()
        configureWindow(rootViewController: navigationController)
        preparationFlow = preparationFlow(navigationController: navigationController)
        preparationFlow.start()
        return true
    }
}

// MARK: - Window configuration

private extension AppDelegate {
    func configureWindow(rootViewController: UIViewController) {
        let window = UIWindow()
        self.window = window
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        addPermissionControlsContainerView(to: window)
    }
    
    func addPermissionControlsContainerView(to window: UIWindow) {
        let permissionControlsContainerView = PermissionControlsContainerComposer.compose(
            headphonesConnectionManager: headphonesConnectionManager,
            loudnessManager: loudnessManager,
            systemVolumeManager: systemVolumeManager
        )
        permissionControlsContainerView.layer.zPosition = 1
        window.addSubview(permissionControlsContainerView)
        permissionControlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                permissionControlsContainerView.leadingAnchor.constraint(
                    equalTo: window.leadingAnchor,
                    constant: 16
                ),
                permissionControlsContainerView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                permissionControlsContainerView.topAnchor.constraint(
                    equalTo: window.topAnchor,
                    constant: 50
                ),
                permissionControlsContainerView.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
}

// MARK: - Preparation Flow

private extension AppDelegate {
    func preparationFlow(navigationController: UINavigationController) -> PreparationFlow {
        return PreparationFlow(
            navigationController: navigationController,
            headphonesPreparationViewController: headphonesPreparationViewController,
            loudnessPreparationViewController: loudnessPreparationViewController
        )
    }
    
    func headphonesPreparationViewController(
        onNextButtonTap: @escaping () -> Void
    ) -> HeadphonesPreparationViewController {
        return HeadphonesPreparationComposer.scene(
            observer: headphonesConnectionManager,
            onNextButtonTap: onNextButtonTap
        )
    }
    
    func loudnessPreparationViewController(
        onNextButtonTap: @escaping () -> Void
    ) -> LoudnessPreparationViewController {
        return LoudnessPreparationComposer.scene(
            observer: loudnessManager,
            onNextButtonTap: onNextButtonTap
        )
    }
}

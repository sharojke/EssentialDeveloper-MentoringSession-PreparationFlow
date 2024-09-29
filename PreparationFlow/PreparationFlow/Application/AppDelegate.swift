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
    private let interruptionsManager: PreparationInterruptionsManageable = PreparationInterruptionsManager()
    private lazy var satisfyDelayedPreparationInterruptionsManager: PreparationInterruptionsManageable = {
        let twoSecondsInNanoseconds: UInt64 = 2_000_000_000
        let satisfyDelayedPreparationInterruptionsManager = SatisfyDelayedPreparationInterruptionsManager(
            decoratee: interruptionsManager,
            satisfyDelayInNanoseconds: twoSecondsInNanoseconds
        )
        return satisfyDelayedPreparationInterruptionsManager
    }()
    
    private var satisfyingSystemVolume: Float { 0.5 }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let navigationController = UINavigationController()
        configureWindow(rootViewController: navigationController)
        bindInterruptionsManger()
        preparationFlow = preparationFlow(navigationController: navigationController)
        preparationFlow.start()
        return true
    }
    
    private func bindInterruptionsManger() {
        Task { [weak self] in
            await self?.headphonesConnectionManager.add { isConnected in
                Task { [weak self] in
                    if isConnected {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(satisfiedInterruption: .headphones)
                    } else {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(triggeredInterruption: .headphones)
                    }
                }
            }
        }
        
        Task { [weak self] in
            await self?.systemVolumeManager.add { volume in
                guard let self else { return }
                
                Task { [weak self] in
                    if volume == self?.satisfyingSystemVolume {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(satisfiedInterruption: .systemVolume)
                    } else {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(triggeredInterruption: .systemVolume)
                    }
                }
            }
        }
        
        Task { [weak self] in
            await self?.loudnessManager.add { loudness in
                Task { [weak self] in
                    if loudness == .quiet {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(satisfiedInterruption: .loudness)
                    } else {
                        await self?.satisfyDelayedPreparationInterruptionsManager.manage(triggeredInterruption: .loudness)
                    }
                }
            }
        }
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
        let permissionControlsContainerView = permissionControlsContainerView()
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
                    constant: 100
                ),
                permissionControlsContainerView.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    private func permissionControlsContainerView() -> PermissionControlsContainerView {
        return PermissionControlsContainerComposer.compose(
            headphonesConnectionManager: headphonesConnectionManager,
            loudnessManager: loudnessManager,
            systemVolumeManager: systemVolumeManager,
            satisfyingSystemVolume: satisfyingSystemVolume
        )
    }
}

// MARK: - Preparation Flow

private extension AppDelegate {
    // MARK: Preparations
    
    func preparationFlow(navigationController: UINavigationController) -> PreparationFlow {
        return PreparationFlow(
            navigationController: navigationController,
            headphonesPreparationController: headphonesPreparationViewController,
            loudnessPreparationController: loudnessPreparationViewController, 
            systemVolumePreparationController: systemVolumePreparationViewController,
            testController: testViewController, 
            headphonesInterruptionController: headphonesInterruptionViewController,
            loudnessInterruptionController: loudnessInterruptionViewController,
            systemVolumeInterruptionController: systemVolumeInterruptionViewController, 
            infoController: infoViewController,
            interruptionsManager: satisfyDelayedPreparationInterruptionsManager
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
            onNextButtonTap: onNextButtonTap,
            onPermissionButtonTap: { [weak microphonePermissionManager] in
                microphonePermissionManager?.allowPermission()
            }
        )
    }
    
    func systemVolumePreparationViewController(
        onNextButtonTap: @escaping () -> Void,
        onShowInfoButtonTap: @escaping () -> Void
    ) -> SystemVolumePreparationViewController {
        return SystemVolumePreparationComposer.scene(
            observer: systemVolumeManager,
            satisfyingSystemVolume: satisfyingSystemVolume,
            onNextButtonTap: onNextButtonTap,
            onShowInfoButtonTap: onShowInfoButtonTap
        )
    }
    
    // MARK: Interruptions
    
    func headphonesInterruptionViewController() -> HeadphonesInterruptionViewController {
        return HeadphonesInterruptionComposer.scene(
            observer: headphonesConnectionManager,
            permissionControlsContainerView: permissionControlsContainerView()
        )
    }
    
    func loudnessInterruptionViewController(
        onTestAnywayButtonTap: @escaping () -> Void
    ) -> LoudnessInterruptionViewController {
        return LoudnessInterruptionComposer.scene(
            observer: loudnessManager,
            permissionControlsContainerView: permissionControlsContainerView(),
            onTestAnywayButtonTap: onTestAnywayButtonTap
        )
    }
    
    func systemVolumeInterruptionViewController() -> SystemVolumeInterruptionViewController {
        return SystemVolumeInterruptionComposer.scene(
            observer: systemVolumeManager,
            permissionControlsContainerView: permissionControlsContainerView(),
            satisfyingSystemVolume: satisfyingSystemVolume
        )
    }
    
    // MARK: Other
    
    func testViewController(onRestartButtonTap: @escaping () -> Void) -> TestViewController {
        return TestViewController(onRestartButtonTap: onRestartButtonTap)
    }
    
    func infoViewController() -> InfoViewController {
        return InfoViewController(permissionControlsContainerView: permissionControlsContainerView())
    }
}

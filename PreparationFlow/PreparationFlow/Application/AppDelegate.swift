import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private lazy var microphonePermissionManager = MicrophonePermissionManager()
    
    private lazy var headphonesConnectionManager: HeadphonesConnectionObservable & HeadphonesConnectionSettable = {
        return HeadphonesConnectionManager()
    }()
    
    private lazy var systemVolumeManager: SystemVolumeObservable & SystemVolumeSettable = {
        return SystemVolumeManager()
    }()
    
    private lazy var loudnessManager: LoudnessObservable & LoudnessSettable = {
        return LoudnessManager(isMicrophonePermissionAllowed: microphonePermissionManager.isPermissionAllowed)
    }()
    
    private lazy var permissionControlsContainerView: PermissionControlsContainerView = {
        let inputs = PreparationInterruption.allCases.map { interruption in
            return switch interruption {
            case .headphones:
                headphonesPermissionControlViewInput()
                
            case .loudness:
                loudnessPermissionControlViewInput()
                
            case .systemVolume:
                systemVolumePermissionControlViewInput()
            }
        }
        
        return PermissionControlsContainerView(inputs: inputs)
    }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureWindow()
        return true
    }
}

// MARK: - Window configuration

private extension AppDelegate {
    func configureWindow() {
        let window = UIWindow()
        self.window = window
        window.rootViewController = HeadphonesPreparationViewController.instantiate { coder in
            return HeadphonesPreparationViewController(coder: coder, any: "")
        }
        window.makeKeyAndVisible()
        addPermissionControlsContainerView(to: window)
    }
    
    func addPermissionControlsContainerView(to window: UIWindow) {
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

// MARK: - PermissionControlView inputs

private extension AppDelegate {
    func headphonesPermissionControlViewInput() -> PermissionControlViewInput {
        let icon = UIImage(systemName: "headphones")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [headphonesConnectionManager] in
                Task {
                    await headphonesConnectionManager.setConnected(false)
                }
            },
            onSatisfy: { [headphonesConnectionManager] in
                Task {
                    await headphonesConnectionManager.setConnected(true)
                }
            }
        )
    }
    
    func loudnessPermissionControlViewInput() -> PermissionControlViewInput {
        let icon = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [loudnessManager] in
                Task {
                    await loudnessManager.set(level: .loud)
                }
            },
            onSatisfy: { [loudnessManager] in
                Task {
                    await loudnessManager.set(level: .quiet)
                }
            }
        )
    }
    
    func systemVolumePermissionControlViewInput() -> PermissionControlViewInput {
        let icon = UIImage(systemName: "speaker.wave.2.fill")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [systemVolumeManager] in
                Task {
                    let random: Float = Float((0...1).randomElement()!)
                    await systemVolumeManager.set(volume: random)
                }
            },
            onSatisfy: { [systemVolumeManager] in
                Task {
                    await systemVolumeManager.set(volume: 0.5)
                }
            }
        )
    }
}

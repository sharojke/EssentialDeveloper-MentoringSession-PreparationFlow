import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var headphonesConnectionManager: HeadphonesConnectionObservable & HeadphonesConnectionSettable = {
        return HeadphonesConnectionManager()
    }()
    
    lazy var systemVolumeManager: SystemVolumeObservable & SystemVolumeSettable = {
        return SystemVolumeManager()
    }()
    
    lazy var loudnessManager: LoudnessObservable & LoudnessSettable = {
       return LoudnessManager()
    }()
    
    lazy var permissionControlsContainerView: PermissionControlsContainerView = {
        let inputs = PreparationInterruption.allCases.map { interruption in
            switch interruption {
            case .headphones:
                let icon = UIImage(systemName: "headphones")!
                return PermissionControlViewInput(
                    icon: icon,
                    onTrigger: {},
                    onSatisfy: {}
                )
                
            case .loudness:
                let icon = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")!
                return PermissionControlViewInput(
                    icon: icon,
                    onTrigger: {},
                    onSatisfy: {}
                )
                
            case .systemVolume:
                let icon = UIImage(systemName: "speaker.wave.2.fill")!
                return PermissionControlViewInput(
                    icon: icon,
                    onTrigger: {},
                    onSatisfy: {}
                )
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
    
    private func configureWindow() {
        let window = UIWindow()
        self.window = window
        window.rootViewController = HeadphonesPreparationViewController.instantiate { coder in
            return HeadphonesPreparationViewController(coder: coder, any: "")
        }
        window.makeKeyAndVisible()
        addPermissionControlsContainerView(to: window)
    }
    
    private func addPermissionControlsContainerView(to window: UIWindow) {
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


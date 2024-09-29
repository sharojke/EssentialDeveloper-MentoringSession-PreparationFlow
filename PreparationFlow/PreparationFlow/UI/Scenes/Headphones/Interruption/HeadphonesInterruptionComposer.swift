import UIKit

enum HeadphonesInterruptionComposer {
    static func scene(
        observer: HeadphonesConnectionObservable,
        permissionControlsContainerView: UIView
    ) -> HeadphonesInterruptionViewController {
        let controller = HeadphonesInterruptionViewController(
            permissionControlsContainerView: permissionControlsContainerView
        )
        
        Task {
            await set(controller, connected: observer.isConnected())
            await observer.add { [weak controller] isConnected in
                set(controller, connected: isConnected)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: HeadphonesInterruptionViewController?,
        connected isConnected: Bool
    ) {
        let title = HeadphonesConnectionTitleProvider.provide(isConnected: isConnected)
        controller?.setTitle(title)
    }
}

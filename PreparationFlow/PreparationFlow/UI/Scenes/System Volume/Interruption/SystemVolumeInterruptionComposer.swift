import UIKit

enum SystemVolumeInterruptionComposer {
    static func scene(
        observer: SystemVolumeObservable,
        permissionControlsContainerView: UIView,
        onShowInfoButtonTap: @escaping () -> Void
    ) -> SystemVolumeInterruptionViewController {
        let controller = SystemVolumeInterruptionViewController(
            permissionControlsContainerView: permissionControlsContainerView,
            onShowInfoButtonTap: onShowInfoButtonTap
        )
        
        Task {
            await set(controller, systemVolume: observer.volume())
            await observer.add { [weak controller] volume in
                set(controller, systemVolume: volume)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: SystemVolumeInterruptionViewController?,
        systemVolume: Float
    ) {
        let (_, title) = SystemVolumeValuesProvider.provide(volume: systemVolume)
        controller?.setTitle(title)
    }
}

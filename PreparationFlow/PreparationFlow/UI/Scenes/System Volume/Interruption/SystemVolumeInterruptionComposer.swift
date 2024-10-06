import UIKit

enum SystemVolumeInterruptionComposer {
    static func scene(
        observer: SystemVolumeObservable,
        permissionControlsContainerView: UIView,
        satisfyingSystemVolume: Float
    ) -> SystemVolumeInterruptionViewController {
        let controller = SystemVolumeInterruptionViewController(
            permissionControlsContainerView: permissionControlsContainerView
        )
        
        // TODO: Move to the composition root
        Task {
            await set(
                controller,
                systemVolume: observer.volume(),
                satisfyingSystemVolume: satisfyingSystemVolume
            )
            await observer.add { [weak controller] volume in
                set(controller, systemVolume: volume, satisfyingSystemVolume: satisfyingSystemVolume)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: SystemVolumeInterruptionViewController?,
        systemVolume: Float,
        satisfyingSystemVolume: Float
    ) {
        let (_, title) = SystemVolumeValuesProvider.provide(
            volume: systemVolume,
            satisfyingVolume: satisfyingSystemVolume
        )
        controller?.setTitle(title)
    }
}

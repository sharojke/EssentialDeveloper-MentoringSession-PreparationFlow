import UIKit

enum SystemVolumePreparationComposer {
    static func scene(
        observer: SystemVolumeObservable,
        satisfyingSystemVolume: Float,
        onNextButtonTap: @escaping () -> Void,
        onShowInfoButtonTap: @escaping () -> Void
    ) -> SystemVolumePreparationViewController {
        let controller = SystemVolumePreparationViewController(
            onNextButtonTap: onNextButtonTap,
            onShowInfoButtonTap: onShowInfoButtonTap
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
        _ controller: SystemVolumePreparationViewController?,
        systemVolume: Float,
        satisfyingSystemVolume: Float
    ) {
        let (isSatisfied, title) = SystemVolumeValuesProvider.provide(
            volume: systemVolume,
            satisfyingVolume: satisfyingSystemVolume
        )
        controller?.setSatisfied(isSatisfied, title: title)
    }
}

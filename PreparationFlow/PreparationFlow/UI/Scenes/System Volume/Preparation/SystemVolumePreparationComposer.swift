import UIKit

enum SystemVolumePreparationComposer {
    static func scene(
        observer: SystemVolumeObservable,
        onNextButtonTap: @escaping () -> Void
    ) -> SystemVolumePreparationViewController {
        let controller = SystemVolumePreparationViewController(onNextButtonTap: onNextButtonTap)
        
        Task {
            await set(controller, systemVolume: observer.volume())
            await observer.add { [weak controller] volume in
                set(controller, systemVolume: volume)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: SystemVolumePreparationViewController?,
        systemVolume: Float
    ) {
        let (isSatisfied, title) = SystemVolumeValuesProvider.provide(volume: systemVolume)
        controller?.setSatisfied(isSatisfied, title: title)
    }
}

import UIKit

private enum SystemVolumePreparationValuesProvider {
    static func provide(
        volume: Float,
        satisfyingVolume: Float = 0.5
    ) -> (isSatisfied: Bool, title: String) {
        let volumeString = Int(volume * 100)
        let title = "System volume is\n\(volumeString)%"
        return (volume == satisfyingVolume, title)
    }
}

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
        let (isSatisfied, title) = SystemVolumePreparationValuesProvider.provide(volume: systemVolume)
        controller?.setSatisfied(isSatisfied, title: title)
    }
}

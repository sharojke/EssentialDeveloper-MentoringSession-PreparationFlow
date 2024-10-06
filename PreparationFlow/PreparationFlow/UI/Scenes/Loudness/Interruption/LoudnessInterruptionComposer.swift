import UIKit

enum LoudnessInterruptionComposer {
    static func scene(
        observer: LoudnessObservable,
        permissionControlsContainerView: UIView,
        onTestAnywayButtonTap: @escaping () -> Void
    ) -> LoudnessInterruptionViewController {
        let controller = LoudnessInterruptionViewController(
            permissionControlsContainerView: permissionControlsContainerView,
            onTestAnywayButtonTap: onTestAnywayButtonTap
        )
        
        // TODO: Move to the composition root
        Task {
            await set(controller, level: observer.level())
            await observer.add { [weak controller] level in
                set(controller, level: level)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: LoudnessInterruptionViewController?,
        level: LoudnessLevel
    ) {
        let (_, title) = LoudnessValuesProvider.provide(level: level)
        controller?.setTitle(title)
    }
}

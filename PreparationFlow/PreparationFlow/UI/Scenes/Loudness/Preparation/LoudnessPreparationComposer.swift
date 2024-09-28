import UIKit

enum LoudnessPreparationComposer {
    static func scene(
        observer: LoudnessObservable,
        onNextButtonTap: @escaping () -> Void,
        onPermissionButtonTap: @escaping () -> Void
    ) -> LoudnessPreparationViewController {
        let controller = LoudnessPreparationViewController(
            onNextButtonTap: onNextButtonTap, 
            onPermissionButtonTap: onPermissionButtonTap
        )
        
        Task {
            await set(controller, level: observer.level())
            await observer.add { [weak controller] level in
                set(controller, level: level)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: LoudnessPreparationViewController?,
        level: LoudnessLevel
    ) {
        let (isLoud, title) = LoudnessValuesProvider.provide(level: level)
        controller?.setLoud(isLoud, title: title)
    }
}

import UIKit

enum LoudnessPreparationValuesProvider {
    static func provide(
        level: LoudnessLevel,
        loud: String = "Loudness is\nNOT OK",
        quiet: String = "Loudness is\nOK"
    ) -> (isLoud: Bool, title: String) {
        return switch level {
        case .loud:
            (true, loud)
            
        case .quiet:
            (false, quiet)
        }
    }
}

enum LoudnessPreparationComposer {
    static func scene(observer: LoudnessObservable) -> LoudnessPreparationViewController {
        let controller = LoudnessPreparationViewController()
        
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
        let (isLoud, title) = LoudnessPreparationValuesProvider.provide(level: level)
        controller?.setLoud(isLoud, title: title)
    }
}

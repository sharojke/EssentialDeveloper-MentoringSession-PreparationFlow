import Foundation

typealias LoudnessManageable = LoudnessObservable & LoudnessSettable

actor LoudnessManager: LoudnessManageable {
    private var _level = LoudnessLevel.loud
    private var subscriptions = [(LoudnessLevel) -> Void]()
    
    init(isMicrophonePermissionAllowed: () -> Bool) {
        // TODO: Uncomment this
//        assert(
//            isMicrophonePermissionAllowed(),
//            "Microphone permission has to be allowed before calling the initializer"
//        )
    }
    
    func level() -> LoudnessLevel {
        return _level
    }
    
    func add(subscription: @escaping (LoudnessLevel) -> Void) {
        subscriptions.append(subscription)
    }
    
    func set(level: LoudnessLevel) {
        _level = level
        subscriptions.forEach { $0(level) }
    }
}

import Foundation

actor SystemVolumeManager: SystemVolumeObservable, SystemVolumeSettable {
    private var _volume = Float.zero
    private var subscriptions = [(Float) -> Void]()
    
    func volume() -> Float {
        return _volume
    }
    
    func add(subscription: @escaping (Float) -> Void) {
        subscriptions.append(subscription)
    }
    
    func set(volume: Float) {
        _volume = volume
        subscriptions.forEach { $0(volume) }
    }
}

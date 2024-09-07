import Foundation

actor HeadphonesConnectionManager: HeadphonesConnectionObservable, HeadphonesConnectionSettable {
    private var _isConnected = false
    private var subscriptions = [(Bool) -> Void]()
    
    func isConnected() -> Bool {
        return _isConnected
    }
    
    func add(subscription: @escaping (Bool) -> Void) {
        subscriptions.append(subscription)
    }
    
    func setConnected(_ isConnected: Bool) {
        _isConnected = isConnected
        subscriptions.forEach { $0(isConnected) }
    }
}

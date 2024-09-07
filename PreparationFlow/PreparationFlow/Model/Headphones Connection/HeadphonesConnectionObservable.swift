import Foundation

protocol HeadphonesConnectionObservable {
    func isConnected() async -> Bool
    func add(subscription: @escaping (Bool) -> Void) async
}

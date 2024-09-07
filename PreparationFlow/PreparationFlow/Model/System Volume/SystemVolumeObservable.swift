import Foundation

protocol SystemVolumeObservable {
    func volume() async -> Float
    func add(subscription: @escaping (Float) -> Void) async
}

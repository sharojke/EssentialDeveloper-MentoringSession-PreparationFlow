import Foundation

protocol LoudnessObservable {
    func level() async -> LoudnessLevel
    func add(subscription: @escaping (LoudnessLevel) -> Void) async
}

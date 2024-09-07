import Foundation

protocol LoudnessSettable {
    func set(level: LoudnessLevel) async
}

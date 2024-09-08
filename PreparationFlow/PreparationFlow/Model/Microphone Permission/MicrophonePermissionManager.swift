import Foundation

final class MicrophonePermissionManager {
    static let shared = MicrophonePermissionManager()
    
    private(set) var isPermissionAllowed = false
    
    private init() {}
    
    func allowPermission() {
        isPermissionAllowed = true
    }
}

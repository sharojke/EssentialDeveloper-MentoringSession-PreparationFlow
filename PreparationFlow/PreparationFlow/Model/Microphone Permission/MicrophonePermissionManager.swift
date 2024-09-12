import Foundation

final class MicrophonePermissionManager {    
    private var _isPermissionAllowed = false
    
    func isPermissionAllowed() -> Bool {
        return _isPermissionAllowed
    }
    
    func allowPermission() {
        _isPermissionAllowed = true
    }
}

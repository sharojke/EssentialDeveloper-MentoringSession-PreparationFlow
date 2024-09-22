import UIKit

enum PermissionControlsContainerComposer {
    static func compose(
        headphonesConnectionManager: HeadphonesConnectionManageable,
        loudnessManager: LoudnessManageable,
        systemVolumeManager: SystemVolumeManageable
    ) -> PermissionControlsContainerView {
        let inputs = PreparationInterruption.ordered.map { interruption in
            return switch interruption {
            case .headphones:
                headphonesPermissionControlViewInput(headphonesConnectionManager)
                
            case .loudness:
                loudnessPermissionControlViewInput(loudnessManager)
                
            case .systemVolume:
                systemVolumePermissionControlViewInput(systemVolumeManager)
            }
        }
        
        return PermissionControlsContainerView(inputs: inputs)
    }
    
    private static func headphonesPermissionControlViewInput(
        _ headphonesConnectionManager: HeadphonesConnectionManageable
    ) -> PermissionControlViewInput {
        let icon = UIImage(systemName: "headphones")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [headphonesConnectionManager] in
                Task {
                    await headphonesConnectionManager.setConnected(false)
                }
            },
            onSatisfy: { [headphonesConnectionManager] in
                Task {
                    await headphonesConnectionManager.setConnected(true)
                }
            }
        )
    }
    
    private static func loudnessPermissionControlViewInput(
        _ loudnessManager: LoudnessManageable
    ) -> PermissionControlViewInput {
        let icon = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [loudnessManager] in
                Task {
                    await loudnessManager.set(level: .loud)
                }
            },
            onSatisfy: { [loudnessManager] in
                Task {
                    await loudnessManager.set(level: .quiet)
                }
            }
        )
    }
    
    private static func systemVolumePermissionControlViewInput(
        _ systemVolumeManager: SystemVolumeManageable
    ) -> PermissionControlViewInput {
        let icon = UIImage(systemName: "speaker.wave.2.fill")!
        return PermissionControlViewInput(
            icon: icon,
            onTrigger: { [systemVolumeManager] in
                Task {
                    let random: Float = Float((0...1).randomElement()!)
                    await systemVolumeManager.set(volume: random)
                }
            },
            onSatisfy: { [systemVolumeManager] in
                Task {
                    await systemVolumeManager.set(volume: 0.5)
                }
            }
        )
    }
}

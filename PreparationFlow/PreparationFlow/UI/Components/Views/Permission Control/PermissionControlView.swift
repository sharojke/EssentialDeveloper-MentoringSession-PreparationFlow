import UIKit

struct PermissionControlViewInput {
    let icon: UIImage
    let onTrigger: () -> Void
    let onSatisfy: () -> Void
}

final class PermissionControlView: UIView, Xibable {
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var input: PermissionControlViewInput!
    
    func setup(input: PermissionControlViewInput) {
        self.input = input
        iconImageView.image = input.icon
    }
    
    @IBAction func triggerButtonPressed() {
        input.onTrigger()
    }
    
    @IBAction func satisfyButtonPressed() {
        input.onSatisfy()
    }
}

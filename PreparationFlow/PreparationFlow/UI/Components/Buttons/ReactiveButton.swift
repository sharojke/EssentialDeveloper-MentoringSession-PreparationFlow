import UIKit

final class ReactiveButton: UIButton {
    var defaultAlpha = CGFloat.defaultAlpha
    
    var highlightAlpha = CGFloat.highlightAlpha
    var highlightScale = CGFloat.highlightScale
    var onHighlighted: ((Bool) -> Void)?
    
    var notEnabledAlpha = CGFloat.notEnabledAlpha
    var onEnabled: ((Bool) -> Void)?
    
    var onUserInteractionEnabled: ((Bool) -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            setHighlighted(
                isHighlighted,
                defaultAlpha: defaultAlpha,
                highlightAlpha: highlightAlpha,
                highlightScale: highlightScale,
                onHighlighted: onHighlighted
            )
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: .reactive) {
                if let onEnabled = self.onEnabled {
                    onEnabled(self.isEnabled)
                } else {
                    self.alpha = self.isEnabled ? self.defaultAlpha : self.notEnabledAlpha
                }
            }
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            UIView.animate(withDuration: .reactive) {
                guard let onUserInteractionEnabled = self.onUserInteractionEnabled else { return }
                
                onUserInteractionEnabled(self.isUserInteractionEnabled)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImage(image(for: .normal), for: .highlighted)
    }
}

// MARK: - CGFloat+Sizes

private extension CGFloat {
    static let defaultAlpha: Self = 1
    static let highlightAlpha: Self = 1
    static let highlightScale: Self = 0.975
    static let notEnabledAlpha: Self = 0.3
}

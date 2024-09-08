import UIKit

extension UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func setHighlighted(
        _ isHighlighted: Bool,
        defaultAlpha: CGFloat = 1,
        highlightAlpha: CGFloat = 0.8,
        highlightScale: CGFloat = 0.975,
        backgroundColor: UIColor? = nil,
        highlightBackgroundColor: UIColor? = nil,
        onHighlighted: ((Bool) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        let alpha = isHighlighted ? highlightAlpha : defaultAlpha
        let scaleTransform = CGAffineTransform(scaleX: highlightScale, y: highlightScale)
        let transform = isHighlighted ? scaleTransform : CGAffineTransform.identity
        let defaultBackgroundColor = backgroundColor ?? self.backgroundColor
        let highlightBackgroundColor = highlightBackgroundColor ?? self.backgroundColor
        let backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
        
        UIView.animate(
            withDuration: .reactive,
            animations: {
                if let onHighlighted {
                    onHighlighted(isHighlighted)
                } else {
                    self.transform = transform
                    self.alpha = alpha
                    self.backgroundColor = backgroundColor
                }
            },
            completion: { _ in
                completion?()
            }
        )
    }
}

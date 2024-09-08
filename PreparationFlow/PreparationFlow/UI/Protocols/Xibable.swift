import UIKit

protocol Xibable where Self: UIView {}

extension Xibable {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static func xibView() -> Self {
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

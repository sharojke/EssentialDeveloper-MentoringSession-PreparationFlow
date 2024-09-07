import UIKit

extension UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func instantiate(creator: @escaping ((NSCoder) -> UIViewController?)) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController(creator: creator) as! Self
    }
}

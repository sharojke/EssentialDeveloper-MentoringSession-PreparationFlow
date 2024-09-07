import UIKit

final class HeadphonesPreparationViewController: UIViewController {
    private let any: Any
    
    init?(coder: NSCoder, any: Any) {
        self.any = any
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.storyboardName) init is not implemented")
    }
}


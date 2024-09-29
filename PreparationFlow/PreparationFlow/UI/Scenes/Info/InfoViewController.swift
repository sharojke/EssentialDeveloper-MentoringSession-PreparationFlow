import UIKit

final class InfoViewController: UIViewController {
    private let permissionControlsContainerView: UIView
    
    init(permissionControlsContainerView: UIView) {
        self.permissionControlsContainerView = permissionControlsContainerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configurePermissionControlsContainerView()
    }
    
    private func configurePermissionControlsContainerView() {
        view.addSubview(permissionControlsContainerView)
        permissionControlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                permissionControlsContainerView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
                ),
                permissionControlsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                permissionControlsContainerView.topAnchor.constraint(
                    equalTo: view.topAnchor,
                    constant: 16
                ),
                permissionControlsContainerView.heightAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
}

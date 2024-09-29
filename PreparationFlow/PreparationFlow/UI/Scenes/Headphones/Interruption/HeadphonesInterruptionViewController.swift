import UIKit

final class HeadphonesInterruptionViewController: UIViewController {
    private let permissionControlsContainerView: UIView
    
    private let headphonesConnectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var safeAreaLayoutGuide: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    
    init(permissionControlsContainerView: UIView) {
        self.permissionControlsContainerView = permissionControlsContainerView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func setTitle(_ title: String) {
        // TODO: Move the threading logic to the composer
        Task { @MainActor [weak self] in
            self?.headphonesConnectionLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configurePermissionControlsContainerView()
        configureHeadphonesConnectionLabel()
        
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
    
    private func configureHeadphonesConnectionLabel() {
        view.addSubview(headphonesConnectionLabel)
        
        NSLayoutConstraint.activate(
            [
                headphonesConnectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                headphonesConnectionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                headphonesConnectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ]
        )
    }
}

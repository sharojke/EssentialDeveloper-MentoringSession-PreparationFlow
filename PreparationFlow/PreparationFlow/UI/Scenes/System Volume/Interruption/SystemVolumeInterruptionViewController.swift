import UIKit

final class SystemVolumeInterruptionViewController: UIViewController {
    private let permissionControlsContainerView: UIView
    
    private let systemVolumeLabel: UILabel = {
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
        // TODO: Move to the composer
        Task { @MainActor [weak self] in
            self?.systemVolumeLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configurePermissionControlsContainerView()
        configureSystemVolumeLabel()
        
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
    
    private func configureSystemVolumeLabel() {
        view.addSubview(systemVolumeLabel)
        
        NSLayoutConstraint.activate(
            [
                systemVolumeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                systemVolumeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                systemVolumeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ]
        )
    }
}

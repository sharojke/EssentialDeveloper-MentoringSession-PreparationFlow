import UIKit

final class SystemVolumeInterruptionViewController: UIViewController {
    private let permissionControlsContainerView: UIView
    private let onShowInfoButtonTap: () -> Void
    
    private let showInfoButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle("Show info", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    init(
        permissionControlsContainerView: UIView,
        onShowInfoButtonTap: @escaping () -> Void
    ) {
        self.permissionControlsContainerView = permissionControlsContainerView
        self.onShowInfoButtonTap = onShowInfoButtonTap
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
            self?.systemVolumeLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureShowInfoButton()
        configurePermissionControlsContainerView()
        configureSystemVolumeLabel()
        
    }
    
    private func configureShowInfoButton() {
        showInfoButton.addTarget(self, action: #selector(showInfoButtonTap), for: .touchUpInside)
        view.addSubview(showInfoButton)
        
        NSLayoutConstraint.activate(
            [
                showInfoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
                showInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                showInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                showInfoButton.heightAnchor.constraint(equalToConstant: 64)
            ]
        )
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
    
    @objc private func showInfoButtonTap() {
        onShowInfoButtonTap()
    }
}

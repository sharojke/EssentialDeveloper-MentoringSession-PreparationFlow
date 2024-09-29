import UIKit

final class LoudnessInterruptionViewController: UIViewController {
    private let permissionControlsContainerView: UIView
    private let onTestAnywayButtonTap: () -> Void
    
    private let testAnywayButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle("Test anyway", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.red.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loudnessLabel: UILabel = {
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
    
    init(permissionControlsContainerView: UIView, onTestAnywayButtonTap: @escaping () -> Void) {
        self.permissionControlsContainerView = permissionControlsContainerView
        self.onTestAnywayButtonTap = onTestAnywayButtonTap
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
            self?.loudnessLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureTestAnywayButton()
        configurePermissionControlsContainerView()
        configureLoudnessLabel()
        
    }
    
    private func configureTestAnywayButton() {
        testAnywayButton.addTarget(self, action: #selector(testAnywayButtonTap), for: .touchUpInside)
        view.addSubview(testAnywayButton)
        
        NSLayoutConstraint.activate(
            [
                testAnywayButton.bottomAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor,
                    constant: -16
                ),
                testAnywayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                testAnywayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                testAnywayButton.heightAnchor.constraint(equalToConstant: 64)
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
    
    private func configureLoudnessLabel() {
        view.addSubview(loudnessLabel)
        
        NSLayoutConstraint.activate(
            [
                loudnessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loudnessLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                loudnessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ]
        )
    }
    
    @objc private func testAnywayButtonTap() {
        onTestAnywayButtonTap()
    }
}

import UIKit

final class TestViewController: UIViewController {
    private let onRestartButtonTap: () -> Void
    
    private let restartButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle("Restart the preparation", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "This is the Test scene\nYou can test the logic here or restart the preparation"
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
    
    init(onRestartButtonTap: @escaping () -> Void) {
        self.onRestartButtonTap = onRestartButtonTap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNextButton()
        configureLabel()
        
    }
    
    private func configureNextButton() {
        restartButton.addTarget(self, action: #selector(restartButtonTap), for: .touchUpInside)
        view.addSubview(restartButton)
        
        NSLayoutConstraint.activate(
            [
                restartButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
                restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                restartButton.heightAnchor.constraint(equalToConstant: 64)
            ]
        )
    }
    
    private func configureLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate(
            [
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
            ]
        )
    }
    
    @objc private func restartButtonTap() {
        onRestartButtonTap()
    }
}

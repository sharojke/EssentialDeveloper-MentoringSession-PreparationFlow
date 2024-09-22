import UIKit

final class LoudnessPreparationViewController: UIViewController {
    private let nextButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func setLoud(_ isLoud: Bool, title: String) {
        // TODO: Move the threading logic to the composer
        Task { @MainActor [weak self] in
            self?.nextButton.isEnabled = !isLoud
            self?.loudnessLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNextButton()
        configureLoudnessLabel()
        
    }
    
    private func configureNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate(
            [
                nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
                nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                nextButton.heightAnchor.constraint(equalToConstant: 64)
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
    
    @objc private func nextButtonTap() {
    }
}

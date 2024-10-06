import UIKit

final class SystemVolumePreparationViewController: UIViewController {
    private let onNextButtonTap: () -> Void
    private let onShowInfoButtonTap: () -> Void
    
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
    
    private let showInfoButton: ReactiveButton = {
        let button = ReactiveButton()
        button.setTitle("Show info", for: .normal)
        button.setTitleColor(.blue, for: .normal)
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
        onNextButtonTap: @escaping () -> Void,
        onShowInfoButtonTap: @escaping () -> Void
    ) {
        self.onNextButtonTap = onNextButtonTap
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
    
    func setSatisfied(_ isSatisfied: Bool, title: String) {
        // TODO: Move to the composer
        Task { @MainActor [weak self] in
            self?.nextButton.isEnabled = isSatisfied
            self?.systemVolumeLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNextButton()
        configureShowInfoButton()
        configureSystemVolumeLabel()
        
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
    
    private func configureShowInfoButton() {
        showInfoButton.addTarget(self, action: #selector(showInfoButtonTap), for: .touchUpInside)
        view.addSubview(showInfoButton)
        
        NSLayoutConstraint.activate(
            [
                showInfoButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
                showInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                showInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                showInfoButton.heightAnchor.constraint(equalToConstant: 64)
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
    
    @objc private func nextButtonTap() {
        onNextButtonTap()
    }
    
    @objc private func showInfoButtonTap() {
        onShowInfoButtonTap()
    }
}

import UIKit

final class HeadphonesPreparationViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func setConnected(_ isConnected: Bool, title: String) {
        // TODO: Move the threading logic to the composer
        Task { @MainActor [weak self] in
            self?.nextButton.isEnabled = isConnected
            self?.headphonesConnectionLabel.text = title
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNextButton()
        configureHeadphonesConnectionLabel()
        
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
    
    @objc private func nextButtonTap() {
    }
}

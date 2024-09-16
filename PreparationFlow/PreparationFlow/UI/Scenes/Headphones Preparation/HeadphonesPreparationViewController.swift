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
    
    private let headphonesConnectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var safeAreaLayoutGuide: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func setConnected(_ isConnected: Bool, image: UIImage) {
        // TODO: Move the threading logic to the composer
        Task { @MainActor in
            nextButton.isEnabled = isConnected
            headphonesConnectionImageView.image = image
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNextButton()
        configureHeadphonesConnectionImageView()
        
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
    
    private func configureHeadphonesConnectionImageView() {
        view.addSubview(headphonesConnectionImageView)
        
        NSLayoutConstraint.activate(
            [
                headphonesConnectionImageView.bottomAnchor.constraint(
                    equalTo: nextButton.topAnchor,
                    constant: -24
                ),
                headphonesConnectionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                headphonesConnectionImageView.heightAnchor.constraint(equalToConstant: 64),
                headphonesConnectionImageView.widthAnchor.constraint(
                    equalTo: headphonesConnectionImageView.heightAnchor
                )
            ]
        )
    }
    
    @objc private func nextButtonTap() {
    }
}

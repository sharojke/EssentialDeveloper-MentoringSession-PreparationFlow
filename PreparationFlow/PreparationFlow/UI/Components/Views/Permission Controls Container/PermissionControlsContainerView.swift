import UIKit

final class PermissionControlsContainerView: UIView {
    private let inputs: [PermissionControlViewInput]
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(inputs: [PermissionControlViewInput]) {
        self.inputs = inputs
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .clear
        addStackView()
        addPermissionsControlViews()
    }
    
    private func addStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    private func addPermissionsControlViews() {
        inputs.forEach { input in
            let permissionControl = PermissionControlView.xibView()
            stackView.addArrangedSubview(permissionControl)
            permissionControl.setup(input: input)
        }
    }
}

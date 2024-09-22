import UIKit

final class PreparationFlow {
    private let navigationController: UINavigationController
    private let headphonesPreparationViewController: (@escaping () -> Void) -> HeadphonesPreparationViewController
    private let loudnessPreparationViewController: (@escaping () -> Void) -> LoudnessPreparationViewController
    
    init(
        navigationController: UINavigationController,
        headphonesPreparationViewController: @escaping (@escaping () -> Void) -> HeadphonesPreparationViewController,
        loudnessPreparationViewController: @escaping (@escaping () -> Void) -> LoudnessPreparationViewController
    ) {
        self.navigationController = navigationController
        self.headphonesPreparationViewController = headphonesPreparationViewController
        self.loudnessPreparationViewController = loudnessPreparationViewController
    }
    
    func start() {
        let headphonesPreparation = headphonesPreparationViewController(showLoudnessPreparation)
        navigationController.setViewControllers([headphonesPreparation], animated: false)
    }
    
    private func showLoudnessPreparation() {
        let loudnessPreparation = loudnessPreparationViewController {}
        navigationController.pushViewController(loudnessPreparation, animated: true)
    }
}

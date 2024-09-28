import UIKit

final class PreparationFlow {
    private let navigationController: UINavigationController
    private let headphonesPreparationViewController: (@escaping () -> Void) -> HeadphonesPreparationViewController
    private let loudnessPreparationViewController: (@escaping () -> Void) -> LoudnessPreparationViewController
    private let systemVolumePreparationViewController: (@escaping () -> Void) -> SystemVolumePreparationViewController
    private let testViewController: (@escaping () -> Void) -> TestViewController
    
    init(
        navigationController: UINavigationController,
        headphonesPreparationViewController: @escaping (@escaping () -> Void) -> HeadphonesPreparationViewController,
        loudnessPreparationViewController: @escaping (@escaping () -> Void) -> LoudnessPreparationViewController,
        systemVolumePreparationViewController: @escaping (@escaping () -> Void) -> SystemVolumePreparationViewController,
        testViewController: @escaping (@escaping () -> Void) -> TestViewController
    ) {
        self.navigationController = navigationController
        self.headphonesPreparationViewController = headphonesPreparationViewController
        self.loudnessPreparationViewController = loudnessPreparationViewController
        self.systemVolumePreparationViewController = systemVolumePreparationViewController
        self.testViewController = testViewController
    }
    
    func start() {
        // TODO: Do I need to weakify self since the flow is held in the app delegate?
        let headphonesPreparation = headphonesPreparationViewController(showLoudnessPreparation)
        navigationController.setViewControllers([headphonesPreparation], animated: false)
    }
    
    private func showLoudnessPreparation() {
        let loudnessPreparation = loudnessPreparationViewController(showSystemVolumePreparation)
        navigationController.pushViewController(loudnessPreparation, animated: true)
    }
    
    private func showSystemVolumePreparation() {
        let systemVolumePreparation = systemVolumePreparationViewController(shotTest)
        navigationController.pushViewController(systemVolumePreparation, animated: true)

    }
    
    private func shotTest() {
        let test = testViewController(start)
        navigationController.setViewControllers([test], animated: true)
    }
}

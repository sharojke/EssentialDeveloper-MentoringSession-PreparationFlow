import UIKit

final class PreparationFlow {
    typealias HeadphonesPreparationController = (@escaping () -> Void) -> HeadphonesPreparationViewController
    typealias LoudnessPreparationController = (@escaping () -> Void) -> LoudnessPreparationViewController
    typealias SystemVolumePreparationController = (
        @escaping () -> Void,
        @escaping () -> Void
    ) -> SystemVolumePreparationViewController
    typealias TestController = (@escaping () -> Void) -> TestViewController
    
    typealias HeadphonesInterruptionController = () -> HeadphonesInterruptionViewController
    typealias LoudnessInterruptionController = (@escaping () -> Void) -> LoudnessInterruptionViewController
    typealias SystemVolumeInterruptionController = () -> SystemVolumeInterruptionViewController
    typealias InfoController = () -> InfoViewController
    
    private let navigationController: UINavigationController
    private let headphonesPreparationController: HeadphonesPreparationController
    private let loudnessPreparationController: LoudnessPreparationController
    private let systemVolumePreparationController: SystemVolumePreparationController
    private let testController: TestController
    private let headphonesInterruptionController: HeadphonesInterruptionController
    private let loudnessInterruptionController: LoudnessInterruptionController
    private let systemVolumeInterruptionController: SystemVolumeInterruptionController
    private let infoController: InfoController
    private let interruptionsManager: PreparationInterruptionsManageable
    
    init(
        navigationController: UINavigationController,
        headphonesPreparationController: @escaping HeadphonesPreparationController,
        loudnessPreparationController: @escaping LoudnessPreparationController,
        systemVolumePreparationController: @escaping SystemVolumePreparationController,
        testController: @escaping TestController,
        headphonesInterruptionController: @escaping HeadphonesInterruptionController,
        loudnessInterruptionController: @escaping LoudnessInterruptionController,
        systemVolumeInterruptionController: @escaping SystemVolumeInterruptionController,
        infoController: @escaping InfoController,
        interruptionsManager: PreparationInterruptionsManageable
    ) {
        self.navigationController = navigationController
        self.headphonesPreparationController = headphonesPreparationController
        self.loudnessPreparationController = loudnessPreparationController
        self.systemVolumePreparationController = systemVolumePreparationController
        self.testController = testController
        self.headphonesInterruptionController = headphonesInterruptionController
        self.loudnessInterruptionController = loudnessInterruptionController
        self.systemVolumeInterruptionController = systemVolumeInterruptionController
        self.infoController = infoController
        self.interruptionsManager = interruptionsManager
        bindInterruptionsManager()
    }
    
    func start() {
        let headphonesPreparation = headphonesPreparationController { [weak self] in
            Task { [weak self] in
                await self?.interruptionsManager.add(observableInterruption: .headphones)
            }
            self?.showLoudnessPreparation()
        }
        navigationController.setViewControllers([headphonesPreparation], animated: false)
    }
    
    private func showLoudnessPreparation() {
        let loudnessPreparation = loudnessPreparationController { [weak self] in
            Task { [weak self] in
                await self?.interruptionsManager.add(observableInterruption: .loudness)
            }
            self?.showSystemVolumePreparation()
        }
        navigationController.pushViewController(loudnessPreparation, animated: true)
    }
    
    private func showSystemVolumePreparation() {
        let systemVolumePreparation = systemVolumePreparationController(
            { [weak self] in
                Task { [weak self] in
                    await self?.interruptionsManager.add(observableInterruption: .systemVolume)
                }
                self?.showTest()
            },
            { [weak self] in
                guard let self else { return }
                
                let infoController = infoController()
                self.navigationController.present(infoController, animated: true)
            }
        )
        navigationController.pushViewController(systemVolumePreparation, animated: true)
    
}
    
    private func showTest() {
        let test = testController(start)
        navigationController.setViewControllers([test], animated: true)
    }
    
    private func bindInterruptionsManager() {
        Task { [weak self] in
            await self?.interruptionsManager.add { currentInterruption in
                let currentInterruptionHandler = {
                    switch currentInterruption {
                    case .headphones:
                        self?.showHeadphonesInterruption()

                    case .systemVolume:
                        self?.showSystemVolumeInterruption()
                        
                    case .loudness:
                        self?.showLoudnessInterruption()
                        
                    case .none:
                        break // TODO: say the current controller that there is no interruption
                    }
                }
                
                Task { @MainActor [weak self] in
                    if let presentedViewController = self?.navigationController.presentedViewController {
                        presentedViewController.dismiss(animated: true, completion: currentInterruptionHandler)
                    } else {
                        currentInterruptionHandler()
                    }
                }
            }
        }
    }
    
    private func showHeadphonesInterruption() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let headphonesInterruption = headphonesInterruptionController()
            navigationController.present(headphonesInterruption, animated: true)
        }
    }
    
    private func showSystemVolumeInterruption() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let systemVolumeInterruption = systemVolumeInterruptionController()
            navigationController.present(systemVolumeInterruption, animated: true)
        }
    }
    
    private func showLoudnessInterruption() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let loudnessInterruption = loudnessInterruptionController {
                Task { [weak self] in
                    await self?.interruptionsManager.remove(observableInterruption: .loudness)
                }
            }
            navigationController.present(loudnessInterruption, animated: true)
        }
    }
}


/// ** QUESTIONS:

/// Handle Swift Concurrency correctly
/// - just look for `Task { @MainActor`. I'm creating `Task` at least twice which is suspicious

/// Starting a new flow:
/// - where to initialize the flow?
/// - where to hold the reference to the flow?
/// - how to remove the prev flow if it is not needed anymore?

import UIKit

enum HeadphonesPreparationComposer {
    static func scene(
        observer: HeadphonesConnectionObservable,
        onNextButtonTap: @escaping () -> Void
    ) -> HeadphonesPreparationViewController {
        let controller = HeadphonesPreparationViewController(onNextButtonTap: onNextButtonTap)
        
        // TODO: Move to the composition root
        Task {
            await set(controller, connected: observer.isConnected())
            await observer.add { [weak controller] isConnected in
                set(controller, connected: isConnected)
            }
        }
        
        return controller
    }
    
    private static func set(
        _ controller: HeadphonesPreparationViewController?,
        connected isConnected: Bool
    ) {
        let title = HeadphonesConnectionTitleProvider.provide(isConnected: isConnected)
        controller?.setConnected(isConnected, title: title)
    }
}

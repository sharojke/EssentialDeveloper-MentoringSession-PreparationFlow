import UIKit

enum HeadphonesPreparationConnectionTitleProvider {
    static func provide(
        isConnected: Bool,
        connected: String = "Headphones are\nCONNECTED",
        disconnected: String = "Headphones are\nNOT CONNECTED"
    ) -> String {
        return isConnected ? connected : disconnected
    }
}

enum HeadphonesPreparationComposer {
    static func scene(
        observer: HeadphonesConnectionObservable,
        onNextButtonTap: @escaping () -> Void
    ) -> HeadphonesPreparationViewController {
        let controller = HeadphonesPreparationViewController(onNextButtonTap: onNextButtonTap)
        
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
        let title = HeadphonesPreparationConnectionTitleProvider.provide(isConnected: isConnected)
        controller?.setConnected(isConnected, title: title)
    }
}

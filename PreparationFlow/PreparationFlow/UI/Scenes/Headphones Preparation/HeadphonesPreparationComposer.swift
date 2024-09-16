import UIKit

enum HeadphonesPreparationConnectionImageProvider {
    static func provide(
        isConnected: Bool,
        connected: UIImage = UIImage(systemName: "headphones")!,
        disconnected: UIImage = UIImage(systemName: "iphone.gen2.radiowaves.left.and.right")!
    ) -> UIImage {
        return isConnected ? connected : disconnected
    }
}

enum HeadphonesPreparationComposer {
    static func scene(observer: HeadphonesConnectionObservable) -> HeadphonesPreparationViewController {
        let controller = HeadphonesPreparationViewController()
        
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
        let image = HeadphonesPreparationConnectionImageProvider.provide(isConnected: isConnected)
        controller?.setConnected(isConnected, image: image)
    }
}

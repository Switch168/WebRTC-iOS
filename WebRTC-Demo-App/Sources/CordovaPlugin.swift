import Foundation
import AVFoundation


@objc(CordovaPlugin) // This class must be accesible from Objective-C.
class CordovaPlugin : CDVPlugin {

    var config = Config.default;
    var window: UIWindow?;
    let rootViewController = AppDelegate.shared.rootViewController
    
    @objc(hello:) func hello(_ command: CDVInvokedUrlCommand) {
        NSLog("CordovaPlugin#hello()");

        
        let newViewController = self.buildMainViewController();
        rootViewController.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    
    private func buildMainViewController() -> UIViewController {
        let signalClient = SignalingClient(serverUrl: self.config.signalingServerUrl)
        let webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
        let mainViewController = MainViewController(signalClient: signalClient,
                                                    webRTCClient: webRTCClient)
        let navViewController = UINavigationController(rootViewController: mainViewController)
        navViewController.navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navViewController.navigationBar.prefersLargeTitles = true
        }
        return navViewController
    }
}

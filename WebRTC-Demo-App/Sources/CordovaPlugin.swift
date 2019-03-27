import Foundation
import AVFoundation


@objc(CordovaPlugin)
class CordovaPlugin : CDVPlugin {
    
    var config: Config!
    
    override func pluginInitialize() {
        NSLog("CordovaPlugin#pluginInitialize()");
        self.config = Config.default
    }

    @objc(hello:) func hello(_ command: CDVInvokedUrlCommand) {
        NSLog("CordovaPlugin#hello()");
        
        //let config = Config.default;
        
        dump(config)
        let alertController = buildMainViewController()
        viewController.present(alertController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    private func buildMainViewController() -> UIViewController {
        NSLog("buildMainViewController()");
        //let config = Config.default;
        
        let signalClient = SignalingClient(serverUrl: config.signalingServerUrl)
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)
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

//
//  AppDelegate.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    private var window: UIWindow?
    
    var window: UIWindow?
//    var config = Config.default
    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = self.buildMainViewController()
//        window.makeKeyAndVisible()
//        self.window = window
//        return true
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    private func buildMainViewController() -> UIViewController {
//        let signalClient = SignalingClient(serverUrl: self.config.signalingServerUrl)
//        let webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
//        let mainViewController = MainViewController(signalClient: signalClient,
//                                                    webRTCClient: webRTCClient)
//        let navViewController = UINavigationController(rootViewController: mainViewController)
//        navViewController.navigationBar.isTranslucent = false
//        if #available(iOS 11.0, *) {
//            navViewController.navigationBar.prefersLargeTitles = true
//        }
//        return navViewController
//    }
}


import Foundation
import AVFoundation


@objc(CDVWebRTCiOS)
class CDVWebRTCiOS: CDVPlugin {

    var webRTCClient: WebRTCClient?
    var eventListener: ((_ data: NSDictionary) -> Void)?
    var callbackId: String? = nil
    var hangupCallbackId: String? = nil
    var openCallbackId: String? = nil

    @objc(createOffer:) func createOffer(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS.createOffer()");
        callbackId = command.callbackId

        let argument = command.argument(at: 0) as? NSDictionary
        let iceServers: [String]? = (argument?["iceServers"] as! [String])

        var username: String?
        var credential: String?

        if(argument?["username"] != nil) {
            username = (argument?["username"] as! String)
        }
        if(argument?["credential"] != nil) {
            credential = (argument?["credential"] as! String)
        }

        self.webRTCClient = WebRTCClient(iceServers: iceServers!, username: username, credential: credential)
        self.webRTCClient?.delegate = self
        self.webRTCClient!.offer { (sdp: RTCSessionDescription) in
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK
            )
            pluginResult?.setKeepCallbackAs(true)
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(acceptOffer:) func acceptOffer(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS . acceptOffer()");
        callbackId = command.callbackId

        let argument = command.argument(at: 0) as? NSDictionary
        let iceServers: [String]? = (argument?["iceServers"] as! [String])

        var username: String?
        var credential: String?

        if(argument?["username"] != nil) {
            username = (argument?["username"] as! String)
        }
        if(argument?["credential"] != nil) {
            credential = (argument?["credential"] as! String)
        }

        let sdp: String? = (argument?["sdp"] as! String)
        let type: RTCSdpType = RTCSessionDescription.type(for: "offer")

        let rtcSessionDescription: RTCSessionDescription = RTCSessionDescription(type: type, sdp: sdp!)


        self.webRTCClient = WebRTCClient(iceServers: iceServers!, username: username, credential: credential)
        self.webRTCClient?.delegate = self
        self.webRTCClient!.set(remoteSdp: rtcSessionDescription) { (Error) in
            self.webRTCClient?.answer(completion: { (sdp: RTCSessionDescription) in
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                pluginResult?.setKeepCallbackAs(true)
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)

                let vc = VideoViewController(webRTCClient: self.webRTCClient!)
                let navViewController = UINavigationController(rootViewController: vc)
                navViewController.navigationBar.isHidden = true
                
                DispatchQueue.main.async(execute: {
                    self.viewController.present(navViewController, animated: true, completion: nil)
                });
            })
        }
    }

    @objc(setRemoteDescription:) func setRemoteDescription(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS.setRemoteDescription()")

        let argument = command.argument(at: 0) as? NSDictionary
        let sdp: String? = (argument?["sdp"] as! String)
        let type: RTCSdpType = RTCSessionDescription.type(for: "answer")

        let rtcSessionDescription: RTCSessionDescription = RTCSessionDescription(type: type, sdp: sdp!)

        self.webRTCClient!.set(remoteSdp: rtcSessionDescription) { (Error) in


            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            pluginResult?.setKeepCallbackAs(true)
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)

            let vc = VideoViewController(webRTCClient: self.webRTCClient!)
            let navViewController = UINavigationController(rootViewController: vc)
            navViewController.navigationBar.isHidden = true

            DispatchQueue.main.async(execute: {
                self.viewController.present(navViewController, animated: true, completion: nil)
            });
        }
    }

    @objc(close:) func close(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS . close")
        self.callbackId = nil
        self.webRTCClient = nil
        self.viewController.dismiss(animated: true)
    }

    @objc(openCallback:) func openCallback(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS . openCallback")
        self.openCallbackId = command.callbackId
    }

    @objc(hangupCallback:) func hangupCallback(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS . hangupCallback")
        self.hangupCallbackId = command.callbackId
    }

}


extension CDVWebRTCiOS: WebRTCClientDelegate {

    func webRTCClient(_ client: WebRTCClient, didIceGatheringStateChanged newState: RTCIceGatheringState) {
        if (newState == RTCIceGatheringState.complete) {
            let sdp = client.getLocalDescription()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: sdp.sdp)
            self.commandDelegate!.send(pluginResult, callbackId: self.callbackId)
        }
    }

    func webRTCClient(_ client: WebRTCClient, didStateChanged stateChanged: RTCSignalingState) {
    }

    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
    }

    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
    }

    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
    }

    func hangup() {
        NSLog("CDVWebRTCiOS . hangupCallback from delegate")
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        pluginResult?.setKeepCallbackAs(true)
        self.commandDelegate!.send(pluginResult, callbackId: self.hangupCallbackId)
    }
    
    func open() {
        NSLog("CDVWebRTCiOS . openCallback from delegate")
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        pluginResult?.setKeepCallbackAs(true)
        self.commandDelegate!.send(pluginResult, callbackId: self.openCallbackId)
    }
}


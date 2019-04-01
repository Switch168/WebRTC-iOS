import Foundation
import AVFoundation

@objc(CDVWebRTCiOS)
class CDVWebRTCiOS: CDVPlugin {

    var webRTCClient: WebRTCClient?
    var eventListener: ((_ data: NSDictionary) -> Void)?
    var callbackId: String? = nil

    @objc(createOffer:) func createOffer(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS.createOffer()");
        callbackId = command.callbackId

        let argument = command.argument(at: 0) as? NSDictionary
        let iceServers: [String]? = (argument?["iceServers"] as! [String])

        self.webRTCClient = WebRTCClient(iceServers: iceServers!)
        self.webRTCClient?.delegate = self
        self.webRTCClient!.offer { (sdp: RTCSessionDescription) in
            let pluginResult = CDVPluginResult( status: CDVCommandStatus_OK
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
        let sdp: String? = (argument?["sdp"] as! String)
        let type: RTCSdpType = RTCSessionDescription.type(for: "offer")

        let rtcSessionDescription: RTCSessionDescription = RTCSessionDescription(type: type, sdp: sdp!)

        self.webRTCClient = WebRTCClient(iceServers: iceServers!)
        self.webRTCClient?.delegate = self
        self.webRTCClient!.set(remoteSdp: rtcSessionDescription) { (Error) in
            self.webRTCClient?.answer(completion: { (sdp: RTCSessionDescription) in
                let pluginResult = CDVPluginResult( status: CDVCommandStatus_OK )
                pluginResult?.setKeepCallbackAs(true)
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)

                let vc = VideoViewController(webRTCClient: self.webRTCClient!)
                let navViewController = UINavigationController(rootViewController: vc)
                navViewController.navigationBar.isHidden = true
                self.viewController.present(navViewController, animated: true, completion: nil)
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
            self.viewController.present(navViewController, animated: true, completion: nil)
        }
    }

    @objc(close:) func close(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS . close")
        self.callbackId = nil
        self.webRTCClient = nil
        self.viewController.dismiss(animated: true)
    }
}


extension CDVWebRTCiOS: WebRTCClientDelegate {

    func webRTCClient(_ client: WebRTCClient, didIceGatheringStateChanged newState: RTCIceGatheringState) {
        if (newState == RTCIceGatheringState.complete) {
            var sdp = client.getLocalDescription()
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
}


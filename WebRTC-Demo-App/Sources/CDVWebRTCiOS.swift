import Foundation
import AVFoundation

@objc(CDVWebRTCiOS)
class CDVWebRTCiOS : CDVPlugin {
    
    var webRTCClient: WebRTCClient?
    //var hasRemoteSdp: Bool!
    
    @objc(createOffer:) func createOffer(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS.createOffer()");
        
        let argument = command.argument(at: 0) as? NSDictionary
        let iceServers: [String]? = (argument?["iceServers"] as! [String])
        
        self.webRTCClient = WebRTCClient(iceServers: iceServers!)
        self.webRTCClient!.offer { (sdp: RTCSessionDescription) in
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: sdp.sdp
            )
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(acceptOffer:) func acceptOffer(_ command: CDVInvokedUrlCommand) {
        NSLog("CDVWebRTCiOS.acceptOffer()");
        
        let argument = command.argument(at: 0) as? NSDictionary
        let iceServers: [String]? = (argument?["iceServers"] as! [String])
        let sdp: String? = (argument?["sdp"] as! String)
        let type: RTCSdpType = RTCSessionDescription.type(for: "offer")
        
        
        let rtcSessionDescription: RTCSessionDescription = RTCSessionDescription(type: type, sdp: sdp!)
        
        self.webRTCClient = WebRTCClient(iceServers: iceServers!)
        self.webRTCClient!.set(remoteSdp: rtcSessionDescription) { (Error) in
            self.webRTCClient?.answer(completion: { (sdp: RTCSessionDescription) in
                let pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: sdp.sdp
                )
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            })
   
        }
    }
    
}


extension CDVWebRTCiOS: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        //        self.localCandidateCount += 1
        //        self.signalClient.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        let textColor: UIColor
        switch state {
        case .connected, .completed:
            textColor = .green
        case .disconnected:
            textColor = .orange
        case .failed, .closed:
            textColor = .red
        case .new, .checking, .count:
            textColor = .black
        }
        DispatchQueue.main.async {
            //            self.webRTCStatusLabel?.text = state.description.capitalized
            //            self.webRTCStatusLabel?.textColor = textColor
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        DispatchQueue.main.async {
            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissView(sender: UIButton) {
        //        self.dismiss(animated: true, completion: nil)
    }
}


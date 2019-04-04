//
//  VideoViewController.swift
//  WebRTC
//
//  Created by Stasel on 21/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit

@IBDesignable class HangButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        updateButton()
    }

    func updateButton() {
        layer.cornerRadius = frame.size.height / 4
        self.backgroundColor = UIColor.red
        self.titleLabel?.textColor = UIColor.white
//        self.contentEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
//        self.imageEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
    
    }
}

class VideoViewController: UIViewController {
    
    
    @IBOutlet weak var speakerOffButton: UIButton!
    @IBOutlet weak var speakerOnButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var unmuteButton: UIButton!
    @IBOutlet private weak var localVideoView: UIView?
    private let webRTCClient: WebRTCClient

    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient
        super.init(nibName: String(describing: VideoViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muteButton.isHidden = true
        speakerOnButton.isHidden = true
        
        #if arch(arm64)
            // Using metal (arm64 only)
            let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
            localRenderer.videoContentMode = .scaleAspectFill
            remoteRenderer.videoContentMode = .scaleAspectFill
        #else
            // Using OpenGLES for the rest
            let localRenderer = RTCEAGLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif

        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer, cameraPosition: .front)
        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.view)
        self.view.sendSubviewToBack(remoteRenderer)
        self.webRTCClient.delegate?.open()
             self.webRTCClient.speakerOn()
    }
    
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    
    @IBAction private func backDidTap(_ sender: Any) {
        self.webRTCClient.stopCaptureLocalVideo()
        self.webRTCClient.close()
        self.dismiss(animated: true)
    }
    @IBAction private func mute(_ sender: Any) {
        self.webRTCClient.unmuteAudio()
        self.muteButton.isHidden = true;
        self.unmuteButton.isHidden = false;
    }
    @IBAction private func unmute(_ sender: Any) {
        self.webRTCClient.muteAudio()
        self.muteButton.isHidden = false;
        self.unmuteButton.isHidden = true;
    }
    @IBAction private func speakerOn(_ sender: Any) {
        self.webRTCClient.speakerOff()
        self.speakerOffButton.isHidden = true;
        self.speakerOnButton.isHidden = false;
    }
    @IBAction private func speakerOff(_ sender: Any) {
        self.webRTCClient.speakerOn()
        self.speakerOffButton.isHidden = false;
        self.speakerOnButton.isHidden = true;
    }
    @IBAction private func reverse(_ sender: Any) {
        self.webRTCClient.toggleCamera()
    }
}

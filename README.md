1. `cordova plugin add https://github.com/Switch168/WebRTC-iOS --nofetch`
2. Pick and download from https://github.com/CocoaPods/Specs/tree/master/Specs/2/c/6/GoogleWebRTC (see podspec source). Or https://dl.google.com/dl/cpdc/045885e08e9437d8/GoogleWebRTC-1.1.27299.tar.gz
3. Drag and drop WebRTC.framework to framework (copy item as needed) + set as embedded binary
4. add `#import <WebRTC/WebRTC.h>` to linked header

### API

```javascript
window.webrtcios.createOffer(
  {
    iceServers: [
      "stun:stun.l.google.com:19302",
      "stun:stun1.l.google.com:19302",
      "stun:stun2.l.google.com:19302",
      "stun:stun3.l.google.com:19302",
      "stun:stun4.l.google.com:19302",
      [
        {
          url: "stun:global.stun:3478?transport=udp"
        },
        {
          credential: "5SR2x8mZK1lTFJW3NVgLGw6UM9C0dja4jI/Hdw3xr+w=",
          url: "turn:global.turn:3478?transport=udp",
          username:
            "cda92e5006c7810494639fc466ecc80182cef8183fdf400f84c4126f3b59d0bb"
        }
      ]
    ]
  },
  (error, sdp) => {
    // send sdp to other side
  }
);


window.webrtcios.acceptOffer({iceServers, sdp: "remoteSdp"}, (localSdp) => {
  // send localSdp to other side
})

window.webrtcios.close()
```

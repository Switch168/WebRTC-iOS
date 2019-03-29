window.webrtcios = {
  createOffer(options, callback) {
    const errorHandler = error => callback(`Error: ${error}`);
    const successHandler = result => callback(null, result);
    window.cordova.exec(successHandler, errorHandler, "WebRTCiOS", "createOffer", [
      options
    ]);
  },
  acceptOffer({iceServers, sdp}, callback) {
    const successHandler = result => callback(null, result);
    const errorHandler = error => callback(`Error: ${error}`);
    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "acceptOffer",
      [{iceServers, sdp}]
    );
  }
};

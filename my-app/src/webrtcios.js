// module.exports = {
//   greet: function (name, successCallback, errorCallback) {
//     cordova.exec(successCallback, errorCallback, "Hello", "greet", [name]);
//   }
// };
module.exports = {
  createOffer: function createOffer(options, callback) {
    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error));
    };

    var successHandler = function successHandler(result) {
      return callback(null, result);
    };

    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "createOffer",
      [options]
    );
  },
  acceptOffer: function acceptOffer(_ref, callback) {
    var iceServers = _ref.iceServers,
      sdp = _ref.sdp;

    var successHandler = function successHandler(result) {
      // we need an sdp from the delegate or dont call back
      if (!result) {
        return;
      }

      callback(null, result);
    };

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error));
    };

    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "acceptOffer",
      [
        {
          iceServers: iceServers,
          sdp: sdp
        }
      ]
    );
  },
  close: function close(callback) {
    var successHandler = function successHandler(result) {
      return callback(null, result);
    };

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error));
    };

    window.cordova.exec(successHandler, errorHandler, "WebRTCiOS", "close", []);
  }
};

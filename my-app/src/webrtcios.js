module.exports = {
  createOffer: function createOffer(options, callback) {
    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }

    var successHandler = function successHandler(result) {
      return callback(null, result)
    }

    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "createOffer",
      [options]
    )
  },
  acceptOffer: function acceptOffer(options, callback) {
    var successHandler = function successHandler(result) {
      // we need an sdp from the delegate or dont call back
      if (!result) {
        return
      }

      callback(null, result)
    }

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }

    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "acceptOffer",
      [
        options
      ]
    )
  },
  setRemoteDescription: function setRemoteDescription(sdp, callback) {
    var successHandler = function successHandler(result) {
      return callback(null, result)
    }

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }


    window.cordova.exec(
      successHandler,
      errorHandler,
      "WebRTCiOS",
      "setRemoteDescription",
      [
        {
          sdp: sdp
        }
      ]
    )
  },
  hangupCallback: function hangupCallback(callback) {
    var successHandler = function successHandler(result) {
      return callback(null, result)
    }

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }

    window.cordova.exec(successHandler, errorHandler, "WebRTCiOS", "hangupCallback", [])
  },

  openCallback: function openCallback(callback) {
    var successHandler = function successHandler(result) {
      return callback(null, result)
    }

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }

    window.cordova.exec(successHandler, errorHandler, "WebRTCiOS", "openCallback", [])
  },

  close: function close(callback) {
    var successHandler = function successHandler(result) {
      return callback(null, result)
    }

    var errorHandler = function errorHandler(error) {
      return callback("Error: ".concat(error))
    }

    window.cordova.exec(successHandler, errorHandler, "WebRTCiOS", "close", [])
  },
}

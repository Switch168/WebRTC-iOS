import { Component } from "inferno";
import "./App.css";

import config from "./config";
const iceServers = config.iceServers;
const websocket = new WebSocket(config.signallingServer);

class App extends Component {
  constructor(props) {
    super(props);

    document.addEventListener("deviceready", () => {
      window.webrtcios.hangupCallback(() => {
        console.log('hangup detected')
        websocket.send(JSON.stringify({ type: "hangup" }));
      })
    }, false);




    this.state = { sdp: [], received: [], message: [], accepted: [], last: [] };
    websocket.onmessage = ({ data }) => {
      console.log("onmessage", data);
      const message = JSON.parse(data);

      this.setState({ received: message.data });
      if (message.type === "answer") {
        window.webrtcios.setRemoteDescription(
          message.data,
          (error, result) => {
            console.log(message.data);
            websocket.send(
              JSON.stringify({ data: result, type: "receiverSdp" })
            );
            this.setState({ sdp: result });
          }
        );
      }
      if (message.type === "hangup") {
        window.webrtcios.close((error, result) => {
          console.log("JS: hangup");
        });
      }
      if (message.type === "offer") {
        this.setState({ sdp: message.data });
      }
    };
  }
  render() {
    return (
      <div className="App">
        <p>{Date.now()}</p>
        <button
          onClick={() => {
            websocket.send(JSON.stringify({ type: "hangup" }));
          }}
        >
          Hangup
        </button>
        <button
          onClick={() => {
            window.webrtcios.createOffer({ iceServers }, (error, result) => {
              console.log("JS", result);
              this.setState({ sdp: result });
            });
          }}
        >
          Step 1 Caller - Test create offer
        </button>
        <div id="sdp" style="height: 50px;overflow:hidden;">
          {this.state.sdp}
        </div>
        <div>{this.state.message}</div>
        <button
          onClick={() =>
            websocket.send(
              JSON.stringify({ type: "offer", data: this.state.sdp })
            )
          }
        >
          Send SDP
        </button>
        <p>Received SDP:</p>
        <div id="received" style="height: 100px;overflow:hidden;">
          {this.state.received}
        </div>
        <div style="height: 50px;overflow:hidden;">{this.state.accepted}</div>
        <button
          onClick={() => {
            if (!this.state.sdp) return;
            const { sdp } = this.state;
            window.webrtcios.acceptOffer(
              { iceServers, sdp: this.state.received },
              (error, result) => {
                this.setState({ accepted: result });
                websocket.send(
                  JSON.stringify({ data: result, type: "answer" })
                );
              }
            );
          }}
        >
          Step 2 Receiver - Test accept offe
        </button>
        <div style="height: 50px;overflow:hidden;">LAST: {this.state.last}</div>
      </div>
    );
  }
}

export default App;

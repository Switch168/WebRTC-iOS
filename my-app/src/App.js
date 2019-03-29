import { version, Component } from "inferno";
import Logo from "./logo";
import "./App.css";

const iceServers = [
  "stun:stun.l.google.com:19302",
  "stun:stun1.l.google.com:19302",
  "stun:stun2.l.google.com:19302",
  "stun:stun3.l.google.com:19302",
  "stun:stun4.l.google.com:19302"
];

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sdp: []
    };
  }
  render() {
    let sdpFromCreateOffer;
    return (
      <div className="App">
        <header className="App-header">
          <Logo width="80" height="80" />
          <p>{`Welcome to Inferno ${version}`}</p>
          <p>{Date.now()}</p>
          <button onClick={() => this.setState({ sdp: "" })}>Clear</button>
          <button
            onClick={() => {
              if (!this.state.sdp) return;
              const { sdp } = this.state;
              window.webrtcios.acceptOffer(
                { iceServers, sdp },
                (error, result) => {
                  console.log(error, result);
                  console.log("acceptOffer sdp", error, sdp);
                }
              );
            }}
          >
            Test accept offer
          </button>{" "}
          <p>Sdp:</p>
          <p>{this.state.sdp}</p>
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>

          <button
            onClick={() => {
              window.webrtcios.createOffer({ iceServers }, (error, result) => {
                this.setState({ sdp: result });
                console.log(sdpFromCreateOffer);
                console.log(typeof sdpFromCreateOffer);
              });
            }}
          >
            Test create offer
          </button>
        </header>
      </div>
    );
  }
}

export default App;

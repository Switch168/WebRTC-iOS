import { render } from "inferno";
import "./index.css";
import App from "./App";
import webrtc from "./webrtcios";

window.webrtcios = webrtc;

render(<App />, document.getElementById("root"));

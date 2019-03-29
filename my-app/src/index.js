import { render } from 'inferno';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

require('./webrtcios');

window.testMomo = function testMomo() {
  console.log("MOMO IS ANGUI")
}

window.testMomo();


// var exec = require('cordova/exec');
console.log('momo');


render(<App />, document.getElementById('root'));
console.log('1')

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister();

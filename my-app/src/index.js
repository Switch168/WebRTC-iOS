import { render } from 'inferno';
import './index.css';
import App from './App';

require('./webrtcios');

render(<App />, document.getElementById('root'));



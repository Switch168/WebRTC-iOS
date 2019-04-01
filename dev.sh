#!/usr/bin/env bash

killbg() {
        for p in "${pids[@]}" ; do
                kill "$p";
        done
}
trap killbg EXIT
pids=()
(cd my-app; npm run start) &
pids+=($!)
(cd signaling; node app.js)

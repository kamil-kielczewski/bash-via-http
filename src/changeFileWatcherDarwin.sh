#!/bin/sh

pkill -f "fswatch -0 ../share/event" # kill old watcher

which fswatch >/dev/null || err "you need 'fswatch' command (brew install fswatch)"
fswatch -0 ../share/event | xargs -0 -n1 ./execScript.sh
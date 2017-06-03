#!/bin/bash
docker build -f Dockerfile -t kkielczewski/bash-via-http .
docker rm -f bash-via-http
par="$*" #get all script parameters and send them to docker
docker run $par -v `pwd`/../share:/share --name bash-via-http kkielczewski/bash-via-http &

chmod -R +x ../eventsHandlers
chmod +x ./execScript.sh
chmod +x ./changeFileWatcherDarwin.sh
chmod +x ./changeFileWatcherLinux.sh
cp -n ../share/event.tmp ../share/event
chmod 666 ../share/event

case `uname` in
Linux) # ubuntu
    nohup ./changeFileWatcherLinux.sh > /dev/null 2>&1 &
   ;;
Darwin) # mac os
    nohup ./changeFileWatcherDarwin.sh > /dev/null 2>&1 &
   ;;
esac
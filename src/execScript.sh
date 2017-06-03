#!/bin/sh
scriptName=`sed '2q;d' ../share/event`

# remove unnamed images
docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}') | :

echo "RUN: " $scriptName
cd ../eventsHandlers/$scriptName
./run.sh


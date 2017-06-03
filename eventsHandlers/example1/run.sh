#!/bin/bash

# Auto deploy
#
# On your github project add web-hook:
#
# hook: POST http://events-handler.your-domain.com/event?name=example1&key=secret_and_hard_password

source ../common_variables
source ../tools.sh

event.authOrDie key secret_and_hard_password

cd $PROJECTS_DIR/your-project

git pull
docker build --squash="true" -t your-project .
docker rmi -f $(docker images -f "dangling=true" -q) | :
docker rm -f your-project | :
docker run -e VIRTUAL_HOST=your-project.your-domain.com --name your-project your-project &

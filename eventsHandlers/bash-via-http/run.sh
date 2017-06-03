#!/bin/bash

# Handle event of self-update (on sub-domain; after git push)
#
# POST http://events-handler.your-domain.com/event?name=bash-via-http&key=secret-password
# BODY ....

source ../common_variables
source ../tools.sh

event.authOrDie key secret-password

cd ../..
git pull
./run.sh -e VIRTUAL_HOST=events-handler.your-domain.com &

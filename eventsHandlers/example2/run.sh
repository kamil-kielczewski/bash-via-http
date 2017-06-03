#!/bin/bash

# 1. copy this directory in current dir and rename it to your event name eg. my-project-bitbicket-push
# 2. Edit run.sh file putting inside your script
# 3. When http request came e.g. GET/POST http://127.0.0.1/event?name=example
#    then run.sh from 'example' directory will be executed on host machine (not docker container)

# Example 1

# Handle event of bitbucket push
#
# POST http://events-handler-subdomain.your-domain.net/event?name=example2&key=xxxxxxxxxxxxxxxxxxxxxx
# BODY {"push":{"changes":[{"new":{"name":"master","type":"branch"}}]}} (this is only (important) part of json  body)

source ../common_variables      # in this file you can putt common variables like $PROJECTS_DIR
source ../tools.sh              # here are tools to authenticate and parse event data

event.authOrDie key xxxxxxxxxxxxxxxxxxxxxx      # check that key in event request vas valid

# Caution!
# Below is only example how to parse json file
# In fact you dont need check branch for which `git push` was invoked - if your repo in server is
# set up on master branch, then if someone push something to develop branch it will no affect
# master branch on git pull

event.getBodyJsonValue '.push.changes[0].new.name' # return $event_BodyJsonValue with path value
branch=$event_BodyJsonValue

event.getBodyJsonValue '.push.changes[0].new.type' # return $event_BodyJsonValue with path value
type=$event_BodyJsonValue

if [ $type = '"branch"' ] && [ $branch = '"master"' ]; then
    # here you make main stuff after git push event (auto-deploy for this project as example)
    # cd ../..
    # git pull
    # ./run.sh -e VIRTUAL_HOST=events-handler.airavana.net &

    # You can use cd $PROJECTS_DIR/your_git_project/ for your other projects
fi


# Example 2

# Below example code write event details in example.output.txt file in current directory
# You can delete below code if you not use it

source ../common_variables
echo 'This Script path: ' `pwd` > example.output.txt
echo 'Project path: '$PROJECTS_DIR >> example.output.txt

eventTimestamp=`sed '5q;d' ../../share/event`
eventParams=`sed '8q;d' ../../share/event`
eventBody=`awk 'NR>10' ../../share/event`
params=(${eventParams//[=&]/ }) # even index is param name (starts from 2), odd index is param value in this array.

case `uname` in
Linux)
    eventTime=`date -d @$eventTimestamp`   # ubuntu
   ;;
Darwin)
    eventTime=`date -r $eventTimestamp`  # macOs
   ;;
esac

echo "Event time:" $eventTime >> example.output.txt
echo "Event params:" $eventParams >> example.output.txt
echo "Second param name:" ${params[2]}', and value:' ${params[3]} >> example.output.txt
echo "Event body:" $eventBody >> example.output.txt


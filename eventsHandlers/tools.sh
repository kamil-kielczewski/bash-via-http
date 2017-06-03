#!/bin/bash

err() {
    echo "$1" >&2; exit 1
}

# Return (as global associative array:
#   event_params
event.getPrams() {
    eventParams=`sed '8q;d' ../../share/event`
    par=(${eventParams//[=&]/ })
    idx=0
    declare -gA event_params
    for i in "${par[@]}"
    do
        if [ $((idx%2)) -eq 0 ]; then
           event_params[${par[idx]}]=${par[idx+1]}
        fi
        idx=$(expr $idx + 1)
    done

    #echo 'key' ${params[key]}

}

# Parameters
# - $1 name of parameter with authentication key
# - $2 value of valid key
#
# Result
# - if event parametes has param $1 which value not equals $2 then stop executing script
event.authOrDie() {
    event.getPrams # return global associative array: event_params
    k=${event_params[$1]}
    if [ "$k" != "$2" ]; then
        echo "Wrong credentials!"
        exit
     fi
}


# Parameters
# - $1 paht in json (writenn in EVENT_BODY section in ../shared/event file)
event.getBodyJsonValue() {
    which jq >/dev/null || err "You need 'jq' command (ubuntu: sudo apt-get install jq) (macOs: brew install jq)"
    eventBody=`awk 'NR>10' ../../share/event`
    event_BodyJsonValue=`echo $eventBody | jq $1`
}
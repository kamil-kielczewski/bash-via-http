#!/bin/sh

pkill -f "inotifywait -q -m -e close_write ../share/event" # kill old watcher

LOG="../share/log.txt"
LOG_SIZE=`stat -c%s $LOG`




which inotifywait >/dev/null || err "you need 'inotifywait' command (sudo apt-get install inotify-tools )"
inotifywait -q -m -e close_write  ../share/event |
while read -r filename event; do

  if [ "$LOG_SIZE" -gt 52428800 ]  # limit = 50MB
  then
    mv $LOG $LOG".old"  # log rotation
  fi

  printf '\n\n\n\n' >> $LOG
  echo '--------- EVENT: ' `date -u +'%F %T UTC'` '---------' >> $LOG
  cat ../share/event >> $LOG
  printf '\n\n--- SCRIPT EVENT PROCESSING ---\n\n' >> $LOG
  ./execScript.sh >> $LOG 2>&1
done

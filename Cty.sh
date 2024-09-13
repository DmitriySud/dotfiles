#!/bin/bash

WINDOW_TITLE="dsudakov@test"

wmctrl -a $WINDOW_TITLE

RET=$?

if [ $RET -eq 1 ] 
then
  login='tsh login --user=dsudakov --proxy=port.bidderstack.com'
  connect='ssh test -ldsudakov -t "byobu"'
  gnome-terminal --window --maximize -- sh -c "$connect || $login && $connect"
fi


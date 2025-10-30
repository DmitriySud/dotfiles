#!/bin/bash

MACHINE=$1
WINDOW_TITLE="dsudakov@$MACHINE"

wmctrl -a $WINDOW_TITLE

RET=$?

if [ $RET -eq 1 ] 
then
  
  #login='tsh login --user=dsudakov --proxy=port.bidderstack.com'
  connect="ssh $MACHINE -ldsudakov -t \"byobu\""
  gnome-terminal --window --maximize -- sh -c 'eval $(ssh-agent -s) && ssh dsudakov@dev -t byobu'
fi


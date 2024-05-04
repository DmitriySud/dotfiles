#!/bin/bash

login='tsh login --user=dsudakov --proxy=port.bidderstack.com'
connect='ssh test -ldsudakov -t "byobu"'
gnome-terminal --window --maximize -- sh -c "$connect || $login && $connect"

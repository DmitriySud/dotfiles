#!/bin/bash

ALIASES="$HOME/repos/dotfiles/aliases.txt"

_exec_comand() 
{

  local result

  result=$(sed -n "s/^$1 \\(.*\\)/\\1/p" "$ALIASES" 2>/dev/null)

  if [ -z "$result" ]; then
    (>&2 echo -e "unknown alias $1") && return 1;
  fi

  echo "run-> $result"

  $result
}

case $1 in
  *) 
    _exec_comand "$1"
    ;;
   
esac



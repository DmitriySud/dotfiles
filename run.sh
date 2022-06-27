#!/bin/zsh

ALIASES="$HOME/repos/dotfiles/aliases.txt"
LOG_COMMAND=false
OPEN_VIM=false
OUT_FILE="$HOME/run.log"
ERR_FILE="$HOME/run.err"

_complete_run()
{
  local all_aliases=()
  while IFS= read -r line; do
    all_aliases+=("$line")
  done <<< "$(sed -e 's/^\([^ ]*\) /\1:/g' $ALIASES 2>/dev/null)"

  _describe "aviable aliases"  all_aliases
}

_exec_comand() 
{

  local result

  result=$(sed -n "s/^$1 \\(.*\\)/\\1/p" "$ALIASES" 2>/dev/null)

  if [ -z "$result" ]; then
    (>&2 echo -e "unknown alias $1") && return 1;
  fi

  if [[ "$LOG_COMMAND" == true ]]; then
    result="($result) 1>$OUT_FILE 2>$ERR_FILE"
  fi

  if [[ "$OPEN_VIM" == true ]]; then
    result+=" || vim $OUT_FILE $ERR_FILE"
  fi

  echo "run: $result"

  eval $result
}


run() 
{
  while [[ $# -gt 0 ]]; do
    case $1 in
      -l|--log) 
        LOG_COMMAND=true
        shift
        ;;
      -v|--vim) 
        OPEN_VIM=true
        shift
        ;;
      *) 
        _exec_comand "$1"
        shift
        ;;
       
    esac
  done
}

compdef _complete_run run

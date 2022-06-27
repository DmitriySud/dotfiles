#!/bin/bash

GET_STAGED="git diff --name-only --cached"
GET_NOT_STAGED="git ls-files --modified"
FILES_MASK=".*\.(cxx|cpp|hpp|h)$"
ALL_FILES="find . -type f -not -path './userver/*' -not -path './build/*' -regextype posix-extended -regex \".*\.(cxx|cpp|hpp|h)$\""

function format-list {
for file in $(eval $1); do
  #[[ $file =~ .*\.(cxx|cpp|hpp|h)$ ]] && echo yes yes yes
  if [[ $file =~ $FILES_MASK ]]; then
    #echo format file : $file
    echo $file | xargs clang-format -i 
  fi
done
}

SMART_FORMATING=0

while (( "$#" )); do
  case "$1" in 
    -s|--smart)
      SMART_FORMATING=1
      shift
      ;;
  esac
done

if [ $SMART_FORMATING -eq 1 ]; then
  #echo smart-formating
  format-list "$GET_STAGED" &&
  #echo -e "\n ha-ha-ha nihua ne rabotaet \n"
  format-list "$GET_NOT_STAGED";
else
  echo just-formating
  format-list "$ALL_FILES"
fi

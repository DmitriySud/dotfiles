#!/bin/bash


cur=$(gsettings get org.gnome.desktop.input-sources sources)

if [[ $cur == "[('xkb', 'us'), ('xkb', 'ru')]" ]];
then
  #echo "chel"
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+dvorak'), ('xkb', 'ru+phonetic_dvorak')]" 
else
  #echo "harosh"
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]" 
fi

#cur=$(gsettings get org.gnome.desktop.input-sources sources)
#echo $cur


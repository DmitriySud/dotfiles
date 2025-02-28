#!/bin/bash

# Paths to wallpapers for each display
LAPTOP_WALLPAPER="$HOME/Pictures/lockscreen.png"
EXTERNAL_WALLPAPER="$HOME/Pictures/came_lockscreen.jpeg"

# Get active monitor and resolution
ACTIVE_MONITOR=$(xrandr --query | grep " connected primary" | awk '{print $1}')
RESOLUTION=$(xrandr | grep -w "$ACTIVE_MONITOR" | awk '{print $4}' | cut -d+ -f1)

# Select the right wallpaper
if [ "$ACTIVE_MONITOR" == "eDP" ]; then
    WALLPAPER=$LAPTOP_WALLPAPER
else
    WALLPAPER=$EXTERNAL_WALLPAPER
fi

# Lock screen image path (unique per monitor)
LOCK_SCREEN_IMAGE="/tmp/lockscreen_${ACTIVE_MONITOR}.png"

# Check if image needs to be regenerated
if [ ! -f "$LOCK_SCREEN_IMAGE" ] || [ "$(identify -format "%wx%h" "$LOCK_SCREEN_IMAGE" 2>/dev/null)" != "$RESOLUTION" ]; then
    echo "Generating lockscreen image for $ACTIVE_MONITOR..."
    convert "$WALLPAPER" -resize "$RESOLUTION"^ -gravity center -extent "$RESOLUTION" "$LOCK_SCREEN_IMAGE"
else
    echo "Using existing lockscreen image for $ACTIVE_MONITOR."
fi

# Lock the screen
i3lock -i "$LOCK_SCREEN_IMAGE"


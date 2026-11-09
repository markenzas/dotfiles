#!/usr/bin/env bash
# Volume/Brightness OSD via swaync notifications
# Usage: osd.sh volume|brightness

TYPE="$1"
HINT_CATEGORY="x-swaync.osd"

notify() {
  local icon="$1" summary="$2" value="$3"
  # Replace any existing OSD notification (same tag)
  notify-send \
    -h string:x-canonical-private-synchronous:osd \
    -h int:value:"$value" \
    -t 1500 \
    -u low \
    "$summary" \
    -i "$icon"
}

case "$TYPE" in
  volume)
    vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    muted=$(echo "$vol_raw" | grep -c MUTED)
    vol=$(echo "$vol_raw" | awk '{printf "%.0f", $2 * 100}')

    if [ "$muted" -eq 1 ]; then
      notify "audio-volume-muted" "󰖁  Muted" 0
    elif [ "$vol" -le 33 ]; then
      notify "audio-volume-low" "󰕿  Volume ${vol}%" "$vol"
    elif [ "$vol" -le 66 ]; then
      notify "audio-volume-medium" "󰖀  Volume ${vol}%" "$vol"
    else
      notify "audio-volume-high" "󰕾  Volume ${vol}%" "$vol"
    fi
    ;;

  brightness)
    bright=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')
    if [ "$bright" -le 33 ]; then
      notify "display-brightness-low" "󰃞  Brightness ${bright}%" "$bright"
    elif [ "$bright" -le 66 ]; then
      notify "display-brightness-medium" "󰃟  Brightness ${bright}%" "$bright"
    else
      notify "display-brightness-high" "󰃠  Brightness ${bright}%" "$bright"
    fi
    ;;

  brightness-device)
    device="$2"
    bright=$(brightnessctl -m -d "$device" | awk -F, '{print $4}' | tr -d '%')
    if [ "$bright" -le 33 ]; then
      notify "display-brightness-low" "󰃞  Brightness ${bright}%" "$bright"
    elif [ "$bright" -le 66 ]; then
      notify "display-brightness-medium" "󰃟  Brightness ${bright}%" "$bright"
    else
      notify "display-brightness-high" "󰃠  Brightness ${bright}%" "$bright"
    fi
    ;;
esac

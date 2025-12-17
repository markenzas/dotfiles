#!/bin/bash

# Watch fcitx5 input method and output JSON for waybar
get_im_status() {
    local current_im
    current_im=$(fcitx5-remote -n 2>/dev/null)
    
    case "$current_im" in
        "keyboard-us"|"keyboard-"*|"")
            echo '{"text": "EN", "tooltip": "English", "class": "english"}'
            ;;
        "mozc"|"anthy"|"kkc")
            echo '{"text": "あ", "tooltip": "日本語 ('"$current_im"')", "class": "japanese"}'
            ;;
        *)
            echo '{"text": "'"${current_im:0:2}"'", "tooltip": "'"$current_im"'", "class": "other"}'
            ;;
    esac
}

get_im_status

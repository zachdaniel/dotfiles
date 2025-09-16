#!/bin/bash

osascript <<EOF
tell application "iTerm"
    tell current session of current window
        write text "q"
        write text "tmux_nvim_open '$1' ${2:-1}"
    end tell
end tell
EOF

exit 0

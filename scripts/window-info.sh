#!/bin/bash
# Outputs JSON for waybar custom module with window title and full hyprctl info as tooltip

info=$(hyprctl activewindow -j 2>/dev/null)

if [ -z "$info" ] || [ "$info" = "null" ]; then
    echo '{"text": "", "tooltip": "No active window", "class": "empty"}'
    exit 0
fi

title=$(echo "$info" | jq -r '.title // ""')
display_title=$(echo "$title" | head -c 40)

tooltip=$(echo "$info" | jq -r '
    "Address: \(.address)\n" +
    "Title: \(.title)\n" +
    "Class: \(.class)\n" +
    "Initial Class: \(.initialClass)\n" +
    "Initial Title: \(.initialTitle)\n" +
    "Workspace: \(.workspace.name) (ID: \(.workspace.id))\n" +
    "Monitor: \(.monitor)\n" +
    "PID: \(.pid)\n" +
    "Size: \(.size[0])x\(.size[1])\n" +
    "Position: \(.at[0]), \(.at[1])\n" +
    "Floating: \(.floating)\n" +
    "Fullscreen: \(.fullscreen)\n" +
    "Pinned: \(.pinned)\n" +
    "XWayland: \(.xwayland)\n" +
    "Grouped: \(.grouped)\n" +
    "Tags: \(.tags)\n" +
    "Swallowing: \(.swallowing)\n" +
    "Focus History ID: \(.focusHistoryID)\n" +
    "Inhibiting Idle: \(.inhibitingIdle)\n" +
    "Content Type: \(.contentType)\n" +
    "Stable ID: \(.stableId)"
')

# Escape for JSON
tooltip_escaped=$(echo "$tooltip" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip()))")

echo "{\"text\": \"${display_title//\"/\\\"}\", \"tooltip\": ${tooltip_escaped}, \"class\": \"active\"}"

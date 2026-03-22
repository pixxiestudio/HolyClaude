#!/bin/bash

# ==============================================================================
# HolyClaude — Pushover Notification Script
# Usage: notify.sh stop | notify.sh error
# Only sends if ~/.claude/notify-on flag file exists AND tokens are set.
# ==============================================================================

FLAG_FILE="/home/claude/.claude/notify-on"
EVENT="${1:-unknown}"

# ---------- Check if notifications are enabled ----------
if [ ! -f "$FLAG_FILE" ]; then
    exit 0
fi

# ---------- Check for required credentials ----------
if [ -z "$PUSHOVER_APP_TOKEN" ] || [ -z "$PUSHOVER_USER_KEY" ]; then
    exit 0
fi

# ---------- Set message based on event ----------
case "$EVENT" in
    stop)
        TITLE="HolyClaude — Task Complete"
        MESSAGE="Claude has finished the current task."
        PRIORITY=0
        ;;
    error)
        TITLE="HolyClaude — Something Went Wrong"
        MESSAGE="A tool use failure occurred. Check the session for details."
        PRIORITY=1
        ;;
    *)
        TITLE="HolyClaude — Notification"
        MESSAGE="Event: $EVENT"
        PRIORITY=0
        ;;
esac

# ---------- Send via Pushover API ----------
curl -s -o /dev/null \
    --form-string "token=$PUSHOVER_APP_TOKEN" \
    --form-string "user=$PUSHOVER_USER_KEY" \
    --form-string "title=$TITLE" \
    --form-string "message=$MESSAGE" \
    --form-string "priority=$PRIORITY" \
    https://api.pushover.net/1/messages.json

exit 0

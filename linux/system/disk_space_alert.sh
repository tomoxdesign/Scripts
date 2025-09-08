#!/bin/bash
# disk_space_alert.sh - Disk space alert script for Linux
# Example usage:
# ./disk_space_alert.sh -d / -t 75 -l -e_to "johndoe@gmail.com" -e_from "me@gmail.com" -company "IPG"

# --- Default configuration ---
DRIVE="/"
THRESHOLD=80
LOG=true
LOG_FILE="disk_alert.log"
EMAIL_TO="johndoe@gmail.com"
EMAIL_FROM="me@gmail.com"
COMPANY="IPG"

# --- Parse command-line arguments ---
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--drive) DRIVE="$2"; shift 2 ;;
        -t|--threshold) THRESHOLD="$2"; shift 2 ;;
        -l|--log) LOG=true; shift ;;
        -f|--log-file) LOG_FILE="$2"; shift 2 ;;
        -e_to|--email-to) EMAIL_TO="$2"; shift 2 ;;
        -e_from|--email-from) EMAIL_FROM="$2"; shift 2 ;;
        -c|--company) COMPANY="$2"; shift 2 ;;
        *) echo "Unknown option $1"; exit 1 ;;
    esac
done

# --- Helper function ---
now() { date +"%Y-%m-%d %H:%M:%S"; }

# --- Start log ---
LINE="[$(now)] Disk Space Alert started for $DRIVE (threshold: $THRESHOLD%)"
echo "$LINE"
$LOG && echo "$LINE" >> "$LOG_FILE"

# --- Check disk space ---
USAGE=$(df -h "$DRIVE" | awk 'NR==2 {gsub("%",""); print $5}')
MSG=""
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    MSG="WARNING: $DRIVE usage is $USAGE% (>= $THRESHOLD%)"
    
    # --- Send email alert ---
    EMAIL_BODY="Disk space alert for company: $COMPANY\nDrive: $DRIVE\nUsage: $USAGE% (Threshold: $THRESHOLD%)"
    if command -v mail >/dev/null 2>&1; then
        echo -e "$EMAIL_BODY" | mail -s "Disk Alert $DRIVE - $COMPANY" -r "$EMAIL_FROM" "$EMAIL_TO"
    else
        echo "[$(now)] WARNING: 'mail' command not found. Cannot send email."
    fi
else
    MSG="$DRIVE usage is $USAGE% (below threshold)"
fi

echo "[$(now)] $MSG"
$LOG && echo "[$(now)] $MSG" >> "$LOG_FILE"

# --- End log ---
LINE="[$(now)] Disk Space Alert finished for $DRIVE"
echo "$LINE"
$LOG && echo "$LINE" >> "$LOG_FILE"

#!/bin/bash
# Universal Port Scanner with optional config and logging

# --- Default configuration ---
IP="192.168.0.101"
START_PORT=1
END_PORT=65535
LOG=false
LOG_FILE="ports.log"

now() { date "+%Y-%m-%d %H:%M:%S"; }

# --- Optional custom configuration ---
read -p "Do you want to use a modified configuration? (y/N): " use_custom
if [[ "$use_custom" == "y" || "$use_custom" == "Y" ]]; then
    read -p "IP address [$IP]: " input
    [ ! -z "$input" ] && IP=$input

    read -p "Start port [$START_PORT]: " input
    [ ! -z "$input" ] && START_PORT=$input

    read -p "End port [$END_PORT]: " input
    [ ! -z "$input" ] && END_PORT=$input

    read -p "Log to file? (y/N): " input
    if [[ "$input" == "y" || "$input" == "Y" ]]; then
        LOG=true
        read -p "Log file [$LOG_FILE]: " input
        [ ! -z "$input" ] && LOG_FILE=$input
    fi
fi

# --- Start log ---
echo "[$(now)] Port Scan started for $IP (ports $START_PORT-$END_PORT)" | tee -a $([ "$LOG" = true ] && echo "$LOG_FILE")

# --- Port scan ---
OPEN_PORTS=()
for PORT in $(seq $START_PORT $END_PORT); do
    nc -z -w1 $IP $PORT &> /dev/null
    if [ $? -eq 0 ]; then
        STATUS="open"
        OPEN_PORTS+=($PORT)
    else
        STATUS="closed"
    fi
    echo "[$(now)] Port $PORT is $STATUS" | tee -a $([ "$LOG" = true ] && echo "$LOG_FILE")
done

# --- Summary ---
echo "[$(now)] Open ports: ${OPEN_PORTS[*]}" | tee -a $([ "$LOG" = true ] && echo "$LOG_FILE")

# --- End log ---
echo "[$(now)] Port Scan finished for $IP" | tee -a $([ "$LOG" = true ] && echo "$LOG_FILE")

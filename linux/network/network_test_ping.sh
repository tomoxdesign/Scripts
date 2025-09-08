#!/bin/bash
# Network Tester - Ping Sweep with user input

# --- Default configuration ---
BASE_IP="192.168.1"
START=1
END=20
LOG_FILE="network_ping.log"

# --- Funkce pro čas ---
now() {
    date "+%Y-%m-%d %H:%M:%S"
}

# --- User input (override defaults) ---
read -p "Base IP [$BASE_IP]: " input
[ ! -z "$input" ] && BASE_IP=$input

read -p "Start [$START]: " input
[ ! -z "$input" ] && START=$input

read -p "End [$END]: " input
[ ! -z "$input" ] && END=$input

read -p "Log file [$LOG_FILE]: " input
[ ! -z "$input" ] && LOG_FILE=$input

# --- Start log ---
echo "[$(now)] Network Ping Test started" | tee -a "$LOG_FILE"

# --- Ping loop ---
for i in $(seq $START $END); do
    ip="$BASE_IP.$i"
    ping -c 1 -W 1 $ip &> /dev/null
    if [ $? -eq 0 ]; then
        msg="$ip is up"
    else
        msg="$ip is down"
    fi
    echo "[$(now)] $msg" | tee -a "$LOG_FILE"
done

# --- End log ---
echo "[$(now)] Network Ping Test finished" | tee -a "$LOG_FILE"

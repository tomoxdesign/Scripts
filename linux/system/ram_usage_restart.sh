#!/bin/bash
# chmod +x ram_usage_restart.sh


# Ziskani hodnot z free (v kB)
total=$(free | awk '/Mem:/ {print $2}')
available=$(free | awk '/Mem:/ {print $7}')

# Vypocet procenta volne pameti
percent=$(( available * 100 / total ))

echo"==============================="
echo "$(date '+%Y-%m-%d %H:%M:%S')"
echo "Celkova RAM: $total kB"
echo "Volna RAM: $available kB"
echo "Volne procento: $percent%"

# Kontrola pod 10 %
if [ "$percent" -lt 10 ]; then
    echo "I will restart device"
    /usr/sbin/reboot -f
fi
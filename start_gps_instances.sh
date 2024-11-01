#!/bin/bash

if [ -z "$GPS_NAME" ] || [ -z "$GPS_PWD" ] || [ -z "$GPS_ADM_PWD" ]; then
    echo "One or more mandatory environment variables are not set" >> /var/log/mohh-gps/mohz.log
    exit 1
fi

export GPS_NAME
export GPS_PWD
export GPS_ADM_PWD
export GPS_PORT=${GPS_PORT:-3658}
export GPS_INSTANCES=${GPS_INSTANCES:-1}

GPS_PORT=$((GPS_PORT - 1))

start_instance() {
    sleep 5 # wait for the previous instance to start

    export WINEPREFIX=/root/.wine
    export WINE=/opt/lutris-GE-Proton8-26-x86_64/bin/wine
    export DISPLAY=

    local port=$1
    echo "============================================================" >> /var/log/mohh-gps/mohz.log
    echo "$(date): Starting instance on port $port" >> /var/log/mohh-gps/mohz.log
    echo "============================================================" >> /var/log/mohh-gps/mohz.log
    $WINE /var/www/mohh-gps/mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port -adminpwd:$GPS_ADM_PWD -easerver >> /var/log/mohh-gps/mohz.log 2>&1 &
}

for i in $(seq 1 $GPS_INSTANCES); do
    port=$(($GPS_PORT + i))
    if ! pgrep -f "mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port" > /dev/null; then
        start_instance $port
    fi
done
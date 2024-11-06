#!/bin/bash

if [ -z "$GPS_NAME" ] || [ -z "$GPS_PWD" ] || [ -z "$GPS_ADM_PWD" ]; then
    echo "One or more mandatory environment variables are not set"
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

    local port=$1
    echo "============================================================"
    echo "$(date): Starting instance on port $port"
    echo "============================================================"

    wine /var/www/mohh-gps/mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port -adminpwd:$GPS_ADM_PWD -easerver &
}

Xvfb :0 -screen 0 1024x768x16 &
winecfg > /dev/null 2>&1

for i in $(seq 1 $GPS_INSTANCES); do
    port=$(($GPS_PORT + i))
    if ! pgrep -f "mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port" > /dev/null; then
        start_instance $port
    fi
done
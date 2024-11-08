#!/bin/bash

if [ -z "$GPS_NAME" ] || [ -z "$GPS_PWD" ] || [ -z "$GPS_ADM_PWD" ]; then
    echo "One or more mandatory environment variables are not set"
    exit 1
fi

export GPS_PORT=${GPS_PORT:-3658}
export GPS_INSTANCES=${GPS_INSTANCES:-1}

if [ ! -d "/root/.wine" ]; then
   winecfg > /dev/null 2>&1
fi

start_instance() {
    sleep 5 # wait for the previous instance to start

    local port=$1
    echo "============================================================"
    echo "$(date): Starting instance on port $port"
    echo "============================================================"

    wine /var/www/mohh-gps/mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port -adminpwd:$GPS_ADM_PWD -easerver &
}

for ((i = 0; i < GPS_INSTANCES; i++)); do
    port=$(($GPS_PORT + i))
    if ! pgrep -f "mohz.exe -name:$GPS_NAME -pwd:$GPS_PWD -port:$port" > /dev/null; then
        start_instance $port
    fi
done
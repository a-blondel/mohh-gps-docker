FROM debian:12.7-slim

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends wine wine32 systemd procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./bin /var/www/mohh-gps
COPY ./start_gps_instances.sh /var/www/mohh-gps/start_gps_instances.sh
COPY ./mohh-gps.service /etc/systemd/system/mohh-gps.service
COPY ./mohh-gps.timer /etc/systemd/system/mohh-gps.timer

RUN mkdir -p /var/log/mohh-gps && \
    touch /var/log/mohh-gps/mohz.log && \
    chmod +x /var/www/mohh-gps/start_gps_instances.sh && \
    systemctl enable mohh-gps.timer

ENTRYPOINT ["/lib/systemd/systemd"]

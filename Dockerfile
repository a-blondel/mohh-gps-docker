FROM debian:12.7

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends wine32 wine64 libwine libwine:i386 fonts-wine wget tar xz-utils procps systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz && \
    tar -xf wine-lutris-GE-Proton8-26-x86_64.tar.xz -C /opt && \
    rm wine-lutris-GE-Proton8-26-x86_64.tar.xz

ENV WINEPREFIX=/root/.wine
ENV WINE=/opt/lutris-GE-Proton8-26-x86_64/bin/wine
ENV DISPLAY=

COPY ./bin /var/www/mohh-gps
COPY ./start_gps_instances.sh /var/www/mohh-gps/start_gps_instances.sh
COPY ./mohh-gps.service /etc/systemd/system/mohh-gps.service
COPY ./mohh-gps.timer /etc/systemd/system/mohh-gps.timer

RUN mkdir -p /var/log/mohh-gps && \
    touch /var/log/mohh-gps/mohz.log && \
    chmod +x /var/www/mohh-gps/start_gps_instances.sh && \
    systemctl enable mohh-gps.timer

ENTRYPOINT ["/lib/systemd/systemd"]

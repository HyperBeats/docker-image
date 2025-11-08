FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=container
ENV HOME=/home/container

RUN useradd -m -d /home/container -s /bin/bash container && \
    ln -s /home/container/ /nonexistent

RUN apt update && apt upgrade -y && \
    apt install -y \
    gcc g++ libgcc-12-dev libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils \
    liblzo2-2 cabextract iproute2 net-tools netcat-traditional telnet libatomic1 \
    libsdl1.2debian libsdl2-2.0-0 libfontconfig1 icu-devtools libunwind8 \
    libssl3 libssl-dev sqlite3 libsqlite3-dev libmariadb-dev-compat \
    locales ffmpeg gnupg2 apt-transport-https software-properties-common \
    ca-certificates tzdata libevent-dev libzip4 libprotobuf32 \
    libfluidsynth3 procps libstdc++6 tini liblua5.3-0 rapidjson-dev


RUN apt install -y locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
    
RUN update-ca-certificates

RUN apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]

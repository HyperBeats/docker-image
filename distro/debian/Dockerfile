FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV         DEBIAN_FRONTEND=noninteractive

# heure fr


RUN          useradd -m -d /home/container -s /bin/bash container

RUN          ln -s /home/container/ /nonexistent

ENV          USER=container HOME=/home/container


## Update base packages
RUN          apt update \
             && apt upgrade -y
RUN apt-get install -y \
             sudo \
             systemd \
             tzdata
#RUN          apt install tzdata -y

ENV TZ=Europe/Paris

# Appliquer le fuseau horaire



## Install dependencies
RUN          apt install -y gcc g++ libgcc1 libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
             libfontconfig libicu67 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadbclient-dev-compat libduktape205 locales ffmpeg gnupg2 apt-transport-https software-properties-common ca-certificates \
             liblua5.3-0 libz-dev rapidjson-dev tzdata libevent-dev libzip4 libprotobuf23 libfluidsynth2 procps

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

## Configure locale
RUN          update-locale lang=en_US.UTF-8 \
             && dpkg-reconfigure --frontend noninteractive locales

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
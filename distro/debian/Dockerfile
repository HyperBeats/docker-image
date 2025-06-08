FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV         DEBIAN_FRONTEND=noninteractive

RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
            && apt install -y \
                curl \
                g++ \
                gcc \
                gdb \
                iproute2 \
                locales \
                net-tools \
                netcat-traditional \
                tar \
                telnet \
                tini \
                tzdata \
                wget \
                xvfb \
                lib32gcc-s1 \
                lib32stdc++6 \
                lib32tinfo6 \
                lib32z1 \
                libcurl3-gnutls:i386 \
                libcurl4-gnutls-dev:i386 \
                libcurl4:i386 \
                libfontconfig1 \
                libgcc-11-dev \
                libgcc-12-dev \
                libncurses5:i386 \
                libsdl1.2debian \
                libsdl2-2.0-0 \
                libsdl2-2.0-0:i386 \
                libssl-dev:i386 \
                libtinfo6:i386


# Temp fix for things that still need libssl1.1
RUN         if [ "$(uname -m)" = "x86_64" ]; then \
                wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
                dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
                rm libssl1.1_1.1.0g-2ubuntu4_amd64.deb; \
            fi

# Set the locale
# Set the locale to French
RUN         sed -i '/fr_FR.UTF-8/s/^# //g' /etc/locale.gen && \
            locale-gen
ENV         LANG=fr_FR.UTF-8
ENV         LANGUAGE=fr_FR:fr
ENV         LC_ALL=fr_FR.UTF-8

# Setup user and working directory
RUN         useradd -m -d /home/container -s /bin/bash container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
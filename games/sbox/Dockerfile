FROM debian:trixie-slim

ARG DOTNET_VERSION=10.0.2

LABEL author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TZ=UTC \
    HOME=/home/container \
    USER=container \
    SRCDS_APPID=1892930 \
    AUTO_UPDATE=1 \
    VALIDATE=1 \
    DISPLAY=:0 \
    XVFB=1 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    DISPLAY_DEPTH=24

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl wget gnupg dirmngr \
        tar unzip xz-utils locales tzdata gosu file procps iproute2 \
        libicu-dev libgdiplus lib32gcc-s1 lib32stdc++6 \
        libfontconfig1 libpulse0 libasound2 \
        xvfb x11-xkb-utils xkb-data xauth && \
    # Génération des locales nécessaires pour Source 2[cite: 7]
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/dotnet && \
    curl -fsSL -o /tmp/dotnet.tar.gz "https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz" && \
    tar -xzf /tmp/dotnet.tar.gz -C /opt/dotnet && \
    rm /tmp/dotnet.tar.gz && \
    ln -s /opt/dotnet/dotnet /usr/local/bin/dotnet

RUN mkdir -p /opt/steamcmd && \
    curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C /opt/steamcmd && \
    chmod +x /opt/steamcmd/steamcmd.sh && \
    chmod -R a+rX /opt/steamcmd

RUN useradd -m -d /home/container -s /bin/bash container
COPY --chmod=0755 entrypoint.sh /entrypoint.sh

USER container
WORKDIR /home/container
CMD ["/bin/bash", "/entrypoint.sh"]
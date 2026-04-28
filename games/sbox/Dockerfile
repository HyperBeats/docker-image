FROM --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
        tar curl gcc g++ wget tini \
        lib32gcc-s1 libgcc-11-dev libgcc-12-dev \
        libcurl4-gnutls-dev:i386 libssl-dev:i386 libcurl4:i386 \
        lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 \
        libncurses5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 \
        iproute2 gdb libsdl1.2debian libfontconfig1 \
        telnet net-tools netcat-traditional tzdata numactl \
    && useradd -m -d /home/container container

# Install .NET 8 Runtime for S&box
RUN mkdir -p /usr/share/dotnet \
    && curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 8.0 --runtime dotnet --install-dir /usr/share/dotnet \
    && rm /tmp/dotnet-install.sh

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:/usr/share/dotnet

# Temp fix for things that still need libssl1.1
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
        dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
        rm libssl1.1_1.1.0g-2ubuntu4_amd64.deb; \
    fi

USER container

ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
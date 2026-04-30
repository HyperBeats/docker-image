FROM --platform=$TARGETOS/$TARGETARCH debian:trixie

LABEL author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # Core runtime (GLIBC / GLIBCXX)
        libc6 libc6:i386 \
        libstdc++6 libstdc++6:i386 \
        libgcc-s1 libgcc-s1:i386 \
        \
        # Base tools
        tar curl gcc g++ wget tini ca-certificates git \
        \
        # Dev / compat
        lib32gcc-s1 libgcc-14-dev \
        \
        # Network / debug
        iproute2 gdb telnet net-tools netcat-traditional tzdata numactl \
        \
        # Graphics / audio
        libfontconfig1 libfreetype6 libxi6 libxcursor1 \
        libxrandr2 libxinerama1 libsdl2-2.0-0 libvulkan1 libopenal1 \
        \
        # 32-bit compat
        libcurl4-gnutls-dev:i386 libssl-dev:i386 libcurl4:i386 \
        lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 \
        libncurses5:i386 libcurl3t64-gnutls:i386 libsdl2-2.0-0:i386 \
        \
        # Misc
        libsdl1.2debian \
    && useradd -m -d /home/container container \
    && rm -rf /var/lib/apt/lists/*

# Install .NET 10 (clean global install)
RUN mkdir -p /usr/share/dotnet \
    && wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 10.0 --install-dir /usr/share/dotnet \
    && rm /tmp/dotnet-install.sh

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:/usr/share/dotnet

# Switch user
USER container

ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
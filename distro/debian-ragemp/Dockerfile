# ----------------------------------
# Environment: debian
# ----------------------------------
    FROM    --platform=$TARGETOS/$TARGETARCH node:16-bookworm

    LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"
    
    ENV     DEBIAN_FRONTEND noninteractive
    
    RUN     useradd -m -d /home/container -s /bin/bash container
    
    RUN     apt update -y \
            && apt upgrade -y \
            && apt install -y g++ gcc libgcc-s1 lib32gcc-s1 gdb libstdc++6 libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat-traditional telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
            libfontconfig1 libicu72 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadb-dev libduktape207 locales ffmpeg gnupg2 apt-transport-https software-properties-common ca-certificates tzdata libgdiplus\ 
            python3 dnsutils build-essential coreutils jq pcregrep tini
    
    RUN     wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
            && dpkg -i packages-microsoft-prod.deb \
            && apt update -y \
            && apt install -y dotnet-sdk-6.0 dotnet-sdk-7.0 libgdiplus

    RUN     wget https://download.visualstudio.microsoft.com/download/pr/40a1f4f5-2f73-4661-9a19-7d55d26ab9dd/6b1c82a2e83a7e3a3b3bbf7a4a4d2eb3/dotnet-sdk-3.1.426-linux-x64.tar.gz \
            -O dotnet-sdk-3.1.tar.gz \
            && mkdir -p /usr/share/dotnet \
            && tar -xzf dotnet-sdk-3.1.tar.gz -C /usr/share/dotnet \
            && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

    
    RUN     update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales
    
    USER    container
    ENV     USER=container HOME=/home/container
    WORKDIR /home/container
    
    STOPSIGNAL SIGINT
    
    COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
    RUN         chmod +x /entrypoint.sh
    ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
    CMD         ["/entrypoint.sh"]
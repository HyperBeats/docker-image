FROM        node:14-bullseye-slim

LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

RUN         apt-get update \
            && apt-get -y install --no-install-recommends ffmpeg iproute2 git sqlite3 python3 tzdata ca-certificates dnsutils build-essential locales \
            && npm -g install npm@latest \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            && useradd -m -d /home/container container \
            && locale-gen en_US.UTF-8

ENV         LC_ALL=en_US.UTF-8
ENV         LANG=en_US.UTF-8
ENV         LANGUAGE=en_US.UTF-8

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]

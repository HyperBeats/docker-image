FROM        --platform=$TARGETOS/$TARGETARCH python:3.7-slim

LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

RUN         apt update \
            && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]

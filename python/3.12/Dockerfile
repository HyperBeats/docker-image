FROM        --platform=$TARGETOS/$TARGETARCH python:3.12-rc-slim-bullseye

LABEL       author="HyperBeats" maintainer="contact-hyperbeats@protonmail.com"

RUN         apt-get update \
            && apt-get -y install --no-install-recommends git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps locales \
            && locale-gen en_US.UTF-8


USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
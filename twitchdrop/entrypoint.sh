#!/bin/sh
set -e

# Ensure persistent directories exist for Pterodactyl.
mkdir -p /home/container/config /home/container/cache
mkdir -p /TwitchDropsMiner

# Link app data to the Pterodactyl data directory.
if [ -e /TwitchDropsMiner/config ] && [ ! -L /TwitchDropsMiner/config ]; then
  rm -rf /TwitchDropsMiner/config
fi
if [ ! -L /TwitchDropsMiner/config ]; then
  ln -s /home/container/config /TwitchDropsMiner/config
fi

if [ -e /TwitchDropsMiner/cache ] && [ ! -L /TwitchDropsMiner/cache ]; then
  rm -rf /TwitchDropsMiner/cache
fi
if [ ! -L /TwitchDropsMiner/cache ]; then
  ln -s /home/container/cache /TwitchDropsMiner/cache
fi

# Map the Pterodactyl allocation port to the web UI port.
if [ -n "${SERVER_PORT:-}" ]; then
  export WEB_LISTENING_PORT="${SERVER_PORT}"
fi

exec /init

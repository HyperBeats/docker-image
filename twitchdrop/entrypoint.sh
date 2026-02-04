#!/bin/sh
set -e

APP_DIR="/home/container/TwitchDropsMiner"

mkdir -p "$APP_DIR/config" "$APP_DIR/cache"
cd "$APP_DIR"

# Map le port Pterodactyl vers l'UI web
if [ -n "${SERVER_PORT:-}" ]; then
  export WEB_LISTENING_PORT="${SERVER_PORT}"
fi

exec /init

#!/bin/bash

#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Give everything time to initialize for preventing SteamCMD deadlock
sleep 1

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

CYAN='\033[0;36m'
RESET_COLOR='\033[0m'
GREEN='\033[0;32m'

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

#!/bin/bash
set -u
cd /home/container

# ---- Banner ----
echo "Running on Debian $(cat /etc/debian_version 2>/dev/null || echo unknown)"
echo "Current timezone: $(cat /etc/timezone 2>/dev/null || echo UTC)"

INTERNAL_IP=$(ip route get 1 2>/dev/null | awk '{print $(NF-2);exit}')
export INTERNAL_IP

: "${SRCDS_APPID:=1892930}"
: "${AUTO_UPDATE:=1}"
: "${STEAM_USER:=anonymous}"
: "${XVFB:=1}"
: "${DISPLAY:=:0}"

# ---- 1. SteamCMD update[cite: 6] ----
STEAMCMD_DIR="/home/container/steamcmd"
if [ ! -x "${STEAMCMD_DIR}/steamcmd.sh" ] && [ -d /opt/steamcmd ]; then
    mkdir -p "${STEAMCMD_DIR}"
    cp -r /opt/steamcmd/. "${STEAMCMD_DIR}/"
    chmod -R u+rwX "${STEAMCMD_DIR}"
fi

if [ "${AUTO_UPDATE}" = "1" ]; then
    echo "[yolk] Updating s&box native Linux binaries..."
    "${STEAMCMD_DIR}/steamcmd.sh" +force_install_dir /home/container +login ${STEAM_USER} ${STEAM_PASS:-} +app_update 1007 +app_update "${SRCDS_APPID}" validate +quit
fi

# ---- 2. Locate sbox-server.dll and setup environment[cite: 6] ----
SBOX_DLL=$(find /home/container -maxdepth 4 -iname 'sbox-server.dll' -type f | head -n 1)
if [ -n "${SBOX_DLL}" ]; then
    cd "$(dirname "${SBOX_DLL}")"
    
    # On cherche le dossier contenant libengine2.so pour synchroniser .NET
    ENGINE_SO=$(find /home/container -name 'libengine2.so' -type f | head -n 1)
    if [ -n "${ENGINE_SO}" ]; then
        ENGINE_DIR=$(dirname "${ENGINE_SO}")
        echo "[yolk] Native engine found in: ${ENGINE_DIR}"
        
        # Copie de dotnet pour tromper la détection du chemin Source 2
        export DOTNET_ROOT="/opt/dotnet"
        cp -f /opt/dotnet/dotnet "${ENGINE_DIR}/dotnet"
        ln -sfn /opt/dotnet/host "${ENGINE_DIR}/host"
        ln -sfn /opt/dotnet/shared "${ENGINE_DIR}/shared"
        chmod +x "${ENGINE_DIR}/dotnet"

        # Injection des chemins de bibliothèques natives
        export LD_LIBRARY_PATH="${ENGINE_DIR}:${ENGINE_DIR}/..:${LD_LIBRARY_PATH:-}"
        
        # Ajustement dynamique du chemin de démarrage
        DOTNET_REL_PATH=".${ENGINE_DIR#/home/container}/dotnet"
        STARTUP="${STARTUP/.\/dotnet/${DOTNET_REL_PATH}}"
    fi
fi

# ---- 3. Xvfb (Empêche le Segfault 139)[cite: 6] ----
if [ "${XVFB}" = "1" ]; then
    if ! pgrep -x Xvfb >/dev/null 2>&1; then
        echo "[yolk] Starting Xvfb on ${DISPLAY}..."
        Xvfb "${DISPLAY}" -screen 0 1024x768x24 -nolisten tcp >/dev/null 2>&1 &
        sleep 2
    fi
fi


echo "   ___  ____ _      __    __ ______  _______________  _______"
echo "  / _ \/ __ \ | /| / /___/ // / __ \/ __/_  __/  _/ |/ / ___/"
echo " / , _/ /_/ / |/ |/ /___/ _  / /_/ /\ \  / / _/ //    / (_ / "
echo "/_/|_|\____/|__/|__/   /_//_/\____/___/ /_/ /___/_/|_/\___/  "                                                             
echo -e "${CYAN}STARTUP /home/container: ${MODIFIED_STARTUP} ${RESET_COLOR}"
echo -e "${CYAN}⟳${RESET_COLOR} Starting Gmod..."
echo -e "${GREEN}✓${RESET_COLOR} Successfully started"

# shellcheck disable=SC2086
eval exec "${MODIFIED_STARTUP}"

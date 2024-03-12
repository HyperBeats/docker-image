#!/bin/bash
cd /home/container || exit 1



# Configure colors
CYAN='\033[0;36m'
RESET_COLOR='\033[0m'
GREEN='\033[0;32m'


# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Print Python Version
python --version

# Replace Startup Variables
# shellcheck disable=SC2086
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo "   ___  ____ _      __    __ ______  _______________  _______"
echo "  / _ \/ __ \ | /| / /___/ // / __ \/ __/_  __/  _/ |/ / ___/"
echo " / , _/ /_/ / |/ |/ /___/ _  / /_/ /\ \  / / _/ //    / (_ / "
echo "/_/|_|\____/|__/|__/   /_//_/\____/___/ /_/ /___/_/|_/\___/  "                                                             
echo -e "${CYAN}STARTUP /home/container: ${MODIFIED_STARTUP} ${RESET_COLOR}"
echo -e "${CYAN}⟳${RESET_COLOR} Starting Python..."
echo -e "${GREEN}✓${RESET_COLOR} Successfully started"

# Run the Server
# shellcheck disable=SC2086
eval ${MODIFIED_STARTUP}

#!/bin/bash
cd /home/container || exit 1

# Configure colors
CYAN='\033[0;36m'
RESET_COLOR='\033[0m'

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Print Node.js Version
node -v

# Replace Startup Variables
# shellcheck disable=SC2086
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e "${CYAN}STARTUP /home/container: ${MODIFIED_STARTUP} ${RESET_COLOR}"
echo -e ""
echo -e ""
echo -e "${CYAN}
    ____                            __  __           __  _            
   / __ \____ _      __            / / / /___  _____/ /_(_)___  ____ _
  / /_/ / __ \ | /| / /  ______   / /_/ / __ \/ ___/ __/ / __ \/ __ `/
 / _, _/ /_/ / |/ |/ /  /_____/  / __  / /_/ (__  ) /_/ / / / / /_/ / 
/_/ |_|\____/|__/|__/           /_/ /_/\____/____/\__/_/_/ /_/\__, /  
                                                             /____/   
${RESET_COLOR}"



# Run the Server
# shellcheck disable=SC2086
eval ${MODIFIED_STARTUP}

#!/bin/bash

# Variables
JUMP_USER="your_jump_user"          # The user you use to log in to the jump server
JUMP_HOST="your.jump.server"        # The hostname or IP address of the jump server
TARGET_USER="your_target_user"      # The user you want to log in as on the target server
TARGET_HOST="$1"                    # The target host passed as an argument to the script
ELEVATE_USER="ansible"              # The user you want to switch to on the jump server

# Temporary SSH config file
SSH_CONFIG=$(mktemp)

# Cleanup function to remove the temporary file
cleanup() {
    rm -f "${SSH_CONFIG}"
}
trap cleanup EXIT

# Create SSH config for the jump server
cat << EOF > "${SSH_CONFIG}"
Host jump-server
    HostName ${JUMP_HOST}
    User ${JUMP_USER}

Host target-server
    HostName ${TARGET_HOST}
    User ${TARGET_USER}
    ProxyCommand ssh -tt -F ${SSH_CONFIG} jump-server sudo su - ${ELEVATE_USER} -c "ssh %h"
EOF

# SSH command to connect to the target server using the temporary config file
ssh -F "${SSH_CONFIG}" target-server

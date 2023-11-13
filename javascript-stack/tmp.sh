#!/bin/bash

# Get the WSL 2 IP address
wslIp=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Run PowerShell command from WSL to update the portproxy
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe "netsh interface portproxy reset; netsh interface portproxy add v4tov4 listenport=3010 listenaddress=0.0.0.0 connectport=3010 connectaddress=$wslIp"

# Start your Node.js application
node /home/strick/school/real-time-chat-analysis/javascript-stack/index.js &

#!/bin/bash

nodePort="3010"
pythonPort="8000"
interface="0.0.0.0"

# Get the WSL 2 IP address
echo "Getting WSL IP"
wslIp=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "IP is $wslIp"

echo "Resetting WSL proxies"
# Run PowerShell command from WSL to update the portproxy
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe "netsh interface portproxy reset;"
echo "Setting WSL NODE port proxy for port $nodePort on interfaces ($interface)"
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe "netsh interface portproxy add v4tov4 listenport=$nodePort listenaddress=$interface connectport=$nodePort connectaddress=$wslIp;"
echo "Setting WSL Python port proxy for port $pythonPort on interfaces ($interface)"
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe "netsh interface portproxy add v4tov4 listenport=$pythonPort listenaddress=$interface connectport=$pythonPort connectaddress=$wslIp;"

# Start your Node.js application

node /home/strick/school/real-time-chat-analysis/javascript-stack/index.js &
cd /home/strick/school/real-time-chat-analysis/python_stack
daphne -p 8000 -b $interface python_stack.asgi:application

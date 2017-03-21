#!/bin/sh
# /etc/init.d/local.sh, called from inittab.
# keep this script simple.

# Workflow:
# check for a script in /mnt/onboard/.adds/
# run commands if the script is found

# Using a PATH under /mnt/onboard/ makes scripts and other software
# avaliable with usb storage. 

# Run dropbear if we can reach the script.
if [ -f /mnt/onboard/.adds/dropbear.sh ]; then

    # Basic network configuration
    hostname kobo   # looks better than (none)
    ifconfig lo up

    # Enable pseudoterminals (aka virtual terminals). 
    # Needed for network logins (telnet,ssh..)
    mkdir -p /dev/pts
    mount -t devpts devpts /dev/pts

    # Run dropbear script.
    /etc/init.d/dropbear.sh start
fi

# Run ota-survive script and enable fmon after a FW Upgrade
# if we can reach the script.
if [ -f /mnt/onboard/.adds/ota-survive.sh ]; then
    /mnt/onboard/.adds/ota-survive.sh
fi

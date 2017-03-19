#!/bin/sh

# start dropbear if present.
if [ -f /mnt/onboard/.adds/dropbear.sh ]; then
    hostname kobo
    ifconfig lo up
    mkdir -p /dev/pts
    mount -t devpts devpts /dev/pts
    /etc/init.d/dropbear.sh start
fi

# fmon survives OTA upgrades from Kobo.
if [ -f /mnt/onboard/.adds/ota-survive.sh ]; then
    /mnt/onboard/.adds/ota-survive.sh
fi

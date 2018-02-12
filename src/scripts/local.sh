#!/bin/sh
# /etc/init.d/local.sh: used to do post-boot stuff

# start dropbear ssh server:
if [ -f /mnt/onboard/.adds/dropbear.sh ]; then
    hostname kobo
    ifconfig lo up
    mkdir -p /dev/pts
    mount -t devpts devpts /dev/pts

    if [ ! -d /etc/dropbear ]; then
        mkdir -pv /etc/dropbear
    fi

    if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
        dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
    fi
    
    fi [ ! -f /etc/dropbear/dropbear_dss_host_key ]; then
        dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
    fi
    /sbin/dropbear -m
fi

# fmon needs this to survive OTA updates
if [ -f /etc/init.d/on-animator-fmon.sh ]; then
    if `grep -q flag /etc/init.d/on-animator.sh `; then
        cp -pRv /etc/init.d/on-animator-fmon.sh /etc/init.d/on-animator.sh
        chmod +x /etc/init.d/on-animator.sh
    fi
fi

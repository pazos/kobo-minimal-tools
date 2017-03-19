#!/bin/sh
case "$1" in
    start )
        if [ ! -d /etc/dropbear ]; then
            mkdir -pv /etc/dropbear
        fi

        if [ ! -f /etc/dropbear/dropbear_rsa_host_key ]; then
            dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
        fi
    
        fi [ ! -f /etc/dropbear/dropbear_dss_host_key ]; then
            dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key
        fi
        dropbear -m
        ;;
    stop )
        killall dropbear
        ;;
esac

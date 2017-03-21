#!/bin/sh
# fmon launcher script, called from /etc/init.d/on-animator.sh
# we're called as a new proccess in background and redirected to /dev/null, 
# so we have plenty of time to check stuff and need a file to write logs.

# Read version information. It doesn't hurts
if [ -f /mnt/onboard/.kobo/version ]; then
    # get fw_version, kernel version and serial number for the device
    serial_number=`cat /mnt/onboard/.kobo/version | cut -d "," -f1`
    kernel_version=`cat /mnt/onboard/.kobo/version | cut -d "," -f2`
    firmware_version=`cat /mnt/onboard/.kobo/version | cut -d "," -f3`
else
    # we usually can't reach this on a working machine.
    # At this point running fmon could mess the things even more
    echo "[fmon]: unable to find /mnt/onboard/.kobo/version !!" >> "$logfile"
    echo "[fmon]: Firmware seems broken, exiting.." >> "$logfile"
    exit 3
fi

# Set a file to log to because stdout > /dev/null
logfile="/tmp/fmon.log"

echo "[fmon] starting on device $serial_number [FW: $firmware_version]" >> "$logfile"
### TRIGGERS ####
# KOReader
if [ -f /mnt/onboard/koreader.png ] && [ -f /mnt/onboard/.adds/koreader/koreader.sh ]; then
    echo "[fmon]: adding a trigger for koreader [FW: $firmware_version]" >> "$logfile"    
    # Workaround for run koreader in recent versions (FW above 4.0)
    if [ "$firmware_version" -gt 4.0 ]; then # fix to support 32 bit framebuffer.
        fmon /mnt/onboard/koreader.png /mnt/onboard/.adds/koreader_alt.sh >/dev/null 2>&1&
    else # run koreader script for old fw versions
        fmon /mnt/onboard/koreader.png /mnt/onboard/.adds/koreader/koreader.sh >/dev/null 2>&1&
    fi
fi
# Vlasovsoft (aka Kobo Qt Launcher for qt apps, aka pbchess, aka kobo launcher, by sergey vlasov)
if [ -f /mnt/onboard/launcher.png ] && [ -f /mnt/onboard/.adds/vlasovsoft/launcher.sh ]; then
    echo "[fmon]: adding a trigger for kobo launcher, by vlasovsoft" >> "$logfile" 
    fmon /mnt/onboard/launcher.png /mnt/onboard/.adds/vlasovsoft/launcher.sh >/dev/null 2>&1&
fi
#
# add custom triggers here...
# 
# fmon /mnt/onboard/usb.png /mnt/onboard/.adds/usbnet.sh
# fmon /mnt/onboard/vnc.png /mnt/onboard/.adds/kvncviewer.sh
# fmon /mnt/onboard/wiki.png /mnt/onboard/.adds/kiwix-serve.sh
# ...
#
### TRIGGERS END ####

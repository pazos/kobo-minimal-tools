#!/bin/sh
# it updates /etc/init.d/on-animator.sh with a template stored in /etc/init.d/on-animator-fmon.sh.
# TODO: make it readable :p

# look for the string "flag" in /etc/on-animator.sh.
if [ `grep flag /etc/init.d/on-animator.sh >/dev/null 2>&1; echo "$?"` -eq 1 ]; then
    # can't find it. file was updated during a FW upgrade
    cp -pRv /etc/init.d/on-animator-fmon.sh /etc/init.d/on-animator.sh
    chmod +x /etc/init.d/on-animator.sh
    # Done restoring fmon for future boots. Now call fmon
    if [ -f /mnt/onboard/.adds/fmon.sh ]; then
        sleep 5 # for safety reasons, this is the first boot post-upgrade :)
        /mnt/onboard/.adds/fmon.sh
    fi
fi

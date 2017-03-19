#!/bin/sh
# update /etc/init.d/on-animator.sh with a template stored in /etc/init.d/on-animator-fmon.sh.
if [ `grep flag /etc/init.d/on-animator.sh >/dev/null 2>&1; echo "$?"` -eq 1 ]; then
    cp -pRv /etc/init.d/on-animator-fmon.sh /etc/init.d/on-animator.sh
    chmod +x /etc/init.d/on-animator.sh
fi

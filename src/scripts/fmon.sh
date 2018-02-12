#!/bin/sh
# fmon launcher script, called from /etc/init.d/on-animator.sh
# mostly from https://github.com/baskerville/fmon/blob/master/fmon.sh

[ -e /mnt/onboard/.kobo/version ] || exit 1

ICONS_DIR="/mnt/onboard/icons"
SCRIPTS_DIR="/mnt/onboard/.adds"

for icon in "${ICONS_DIR}"/*.png; do
    app=$(basename "$icon" .png)
    script="${SCRIPTS_DIR}/${app}/${app}.sh"
    logfile="/tmp/fmon-${app}.log"
    
    echo "[fmon]:registering new trigger: ${icon}, linked with ${script}" >> $logfile"
    /sbin/fmon "$icon" "$script" >> "$logfile" 2>&1 &
done

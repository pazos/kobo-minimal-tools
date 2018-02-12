#!/bin/sh
# fmon launcher script, called from /etc/init.d/on-animator.sh
# mostly from https://github.com/baskerville/fmon/blob/master/fmon.sh

[ -e /mnt/onboard/.kobo/version ] || exit 1

SD_ROOT=/mnt/onboard
ICONS_DIR="${SD_ROOT}/icons"
SCRIPTS_DIR="${SD_ROOT}/.adds"
LOGFILE="/tmp/fmon.log"

echo "[fmon]: starting on FW: ${firmware_version}" >> "$LOGFILE"
for icon in "${ICONS_DIR}"/*.png; do
    app=$(basename "$icon" .png)
    script="${SCRIPTS_DIR}/${app}/${app}.sh"
    echo "[fmon]:registering new trigger: ${icon}, linked with ${script}" >> "$LOGFILE"
    /sbin/fmon "$icon" "$script" > "$LOGFILE" 2>&1 &
done

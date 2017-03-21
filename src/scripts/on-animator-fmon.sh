#!/bin/sh
#---fmon-enabled
PRODUCT=`/bin/kobo_config.sh 2>/dev/null`;
[ $PRODUCT != trilogy ] && PREFIX=$PRODUCT-

i=0;
flag=0;
while true; do
        i=$((((i + 1)) % 11));
        zcat /etc/images/$PREFIX\on-$i.raw.gz | /usr/local/Kobo/pickel showpic 1;
        if [ "$flag" -eq 0 ]; then
            if [ -e /mnt/onboard/.adds/fmon.sh ]; then
                /mnt/onboard/.adds/fmon.sh &
                flag=1
            fi
        fi
        usleep 250000;
done

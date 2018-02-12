#!/bin/bash
TC="arm-linux-gnueabihf"
DIR=`realpath "${0%/*}"`
FMON_PATH="$DIR"/build/sbin
INIT_PATH="$DIR"/build/etc/init.d
ICON_PATH="$DIR"/build/mnt/onboard/icons
ADDS_PATH="$DIR"/build/mnt/onboard/.adds
DROPBEAR="dropbear-2016.74"

if [ ! -d "$DIR"/src/"$DROPBEAR".tar.bz2 ]; then
    curl -B https://matt.ucc.asn.au/dropbear/releases/"$DROPBEAR".tar.bz2 > src/"$DROPBEAR".tar.bz2
fi

case "$1" in
    build )
        mkdir -pv "$ADDS_PATH" "$INIT_PATH" "$FMON_PATH"
        ( cd "$DIR"/src/config && cp -pRv inittab passwd "$DIR"/build/etc/ )
        ( cd "$DIR"/src/scripts && cp -pRv local.sh on-animator-fmon.sh "$INIT_PATH" )
        ( cd src && tar -xvf "$DROPBEAR".tar.bz2 )
        ( cd src/"$DROPBEAR" && patch -Np1 -i ../patches/00-dropbear-enable-scp-binary.patch;
            ./configure --host="$TC" --prefix="$DIR"/build --disable-zlib CC="$TC"-gcc LD="$TC"-ld;
            make; make install )
        arm-linux-gnueabihf-g++ "$DIR"/src/fmon.cpp -o "$FMON_PATH"/fmon -Wl,-s
	
	if [ -d "$DIR"/bin ]; then
            ( cd "$DIR"/build/bin && for i in `ls .`; do "$TC"-strip "$i"; done )
        fi

        if [ -d "$DIR"/sbin ]; then
	        ( cd "$DIR"/build/sbin && for i in `ls .`; do "$TC"-strip "$i"; done )
        fi

        # Create the upgrade package:
	rm -rfv "$DIR"/build/share
	rm -rf "$DIR"/KoboRoot.tgz
        ( cd "$DIR"/build && tar -cvzf ../KoboRoot.tgz . )
	;;
    clean )
	    rm -rfv "$DIR"/build "$DIR"/KoboRoot.tgz "$DIR"/src/"$DROPBEAR"
	;;
esac

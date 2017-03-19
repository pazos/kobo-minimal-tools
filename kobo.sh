#!/bin/bash
TC="arm-linux-gnueabihf"
DIR=`realpath "${0%/*}"`
FMON_PATH="$DIR"/build/bin
INIT_PATH="$DIR"/build/etc/init.d
ADDS_PATH="$DIR"/build/mnt/onboard/.adds
#--------------------------------
source "$DIR"/config.txt
#-------------------------
DROPBEAR="dropbear-2016.74"
URL_DROPBEAR=https://matt.ucc.asn.au/dropbear/releases/"$DROPBEAR".tar.bz2

do_dropbear(){
if [ ! -d src/"$DROPBEAR" ]; then
  curl -B "$URL_DROPBEAR" > src/"$DROPBEAR".tar.bz2
  ( cd src && tar -xvf "$DROPBEAR".tar.bz2 )
  ( cd src/"$DROPBEAR" && patch -Np1 -i ../patches/00-dropbear-enable-scp-binary.patch;
    ./configure --host="$TC" --prefix="$DIR"/build --disable-zlib CC="$TC"-gcc LD="$TC"-ld;
    make; make install )
fi
}

do_fmon(){
    echo "Building fmon"
    mkdir -p "$FMON_PATH"
    arm-linux-gnueabihf-g++ "$DIR"/src/fmon.cpp -o "$FMON_PATH"/fmon -Wl,-s
}

case "$1" in
    build )
        if [ ! "$build_sshd" == "yes" ] && [ ! "$build_fmon" == "yes" ]; then
            echo "nothing to build, please check config.txt"
            exit 2
        fi
        # install common files------
        mkdir -p "$INIT_PATH"
        ( cd "$DIR"/src/scripts && cp -pRv inittab "$DIR"/build/etc/inittab )
        ( cd "$DIR"/src/scripts && cp -pRv rc.local "$INIT_PATH" )
        #---------------------------
        if [ "$build_sshd" == "yes" ]; then
	        do_dropbear
            rm -rfv "$DIR"/build/share
            ( cd "$DIR"/src/scripts && cp -pRv dropbear.sh "$INIT_PATH"/dropbear.sh )
            chmod +x "$DIR"/build/etc/init.d/dropbear.sh
        fi

        if [ "$build_fmon" == "yes" ]; then
	        do_fmon
            mkdir -pv "$ADDS_PATH"
            ( cd "$DIR"/src/scripts && cp -pRv on-animator-fmon.sh "$INIT_PATH"/on-animator.sh )
            ( cd "$DIR"/src/scripts && cp -pRv fmon.sh "$ADDS_PATH" )
            chmod +x "$INIT_PATH"/on-animator.sh
            if [ "$ota_survive" == "yes" ]; then
                ( cd "$DIR"/src/scripts && cp -pRv ota-survive.sh on-animator-fmon.sh "$DIR"/build/etc/init.d )
            fi
            if [ "$add_png_koreader" == "yes" ]; then
                ( cd "$DIR"/src/resources && cp -pRv koreader.png "$DIR"/build/mnt/onboard/koreader.png )
            fi
            if [ "$add_png_launcher" == "yes" ]; then
                ( cd "$DIR"/src/resources && cp -pRv launcher.png "$DIR"/build/mnt/onboard/launcher.png )
            fi
        fi

        # strip built binaries------
	if [ -d "$DIR"/bin ]; then
            ( cd "$DIR"/build/bin && for i in `ls .`; do "$TC"-strip "$i"; done )
        fi

        if [ -d "$DIR"/sbin ]; then
	        ( cd "$DIR"/build/sbin && for i in `ls .`; do "$TC"-strip "$i"; done )
        fi #------------------------

        # Create the upgrade package:
	rm -rf "$DIR"/KoboRoot.tgz
        ( cd "$DIR"/build && tar -cvzf ../KoboRoot.tgz . )
	;;
    clean )
	    rm -rfv "$DIR"/build "$DIR"/src/dropbear* "$DIR"/KoboRoot.tgz
	;;
esac

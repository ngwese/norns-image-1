#!/bin/sh

set -u
set -e

BOARD_DIR="$(dirname $0)"

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# ugly hack to get custom overlays into the image
OVERLAYS="monome-snd ssd1322-spi norns-buttons-encoders"
OVERLAYS_BUILD_OUTPUT=${BUILD_DIR}/linux-custom/arch/arm/boot/dts/overlays
OVERLAYS_TARGET=${BINARIES_DIR}/rpi-firmware/overlays
for overlay in $OVERLAYS
do
	cp -v ${OVERLAYS_BUILD_OUTPUT}/${overlay}.dtbo ${OVERLAYS_TARGET}/
done

# break out into common post-build
ln -fs ../norns.target \
		${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/norns.target

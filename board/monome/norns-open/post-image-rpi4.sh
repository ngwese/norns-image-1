#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="rpi4"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# FIXME?: disable all of this now that custom config.txt and cmdline.txt files are being added in post-build-rpi4.sh
for arg in "$@"
do
	case "${arg}" in
		--add-pi3-miniuart-bt-overlay)
		if ! grep -qE '^dtoverlay=' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=pi3-miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi3 ttyAMA0 serial console
dtoverlay=pi3-miniuart-bt
__EOF__
		fi
		;;
		--aarch64)
		# Run a 64bits kernel (armv8)
		sed -e '/^kernel=/s,=.*,=Image,' -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		if ! grep -qE '^arm_64bit=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_64bit=1
__EOF__
		fi

		# Enable uart console
		if ! grep -qE '^enable_uart=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable rpi3 ttyS0 serial console
enable_uart=1
__EOF__
		fi
		;;
		--gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
		# Set GPU memory
		gpu_mem="${arg:2}"
		sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		;;
		--add-norns-software-shutdown-overlay)
		echo "Enabling norns software shutdown"
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Enable software shutdown
dtoverlay=gpio-poweroff:gpiopin=12,active_low=1
__EOF__
		;;
		--add-norns-display-overlay)
		echo "Enabling norns display"
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Display
# Connected using SPI
dtparam=spi=on
dtoverlay=ssd1322-spi
__EOF__
		;;
		--add-norns-soundcard-overlay)
		echo "Enabling norns soundcard"
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Soundcard
# Connected using I2S
# CS4270 codec used by soundcard connected using I2C
dtparam=i2s=on
dtparam=i2c=on
dtoverlay=monome-snd
__EOF__
		;;
		--add-norns-battery-overlay)
		echo "Enabling norns battery management"
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Battery management
dtoverlay=bq27441
__EOF__
		;;
		--add-norns-control-overlay)
		echo "Enabling norns buttons and encoders"
		cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# Buttons and encoders
dtoverlay=norns-buttons-encoders
__EOF__
		;;
	esac

done

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?

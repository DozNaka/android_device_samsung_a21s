#!/bin/bash

# Source Configs
source $CONFIG

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directry
cd $SYNC_PATH

# Sync Branch (will be used to fix legacy build system errors)
if [ -z "$SYNC_BRANCH" ]; then
    export SYNC_BRANCH=$(echo ${FOX_BRANCH} | cut -d_ -f2)
fi

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 10G
else
    ccache -M ${CCACHE_SIZE}
fi

# Empty the VTS Makefile
if [ "$FOX_BRANCH" = "fox_11.0" ]; then
    rm -rf frameworks/base/core/xsd/vts/Android.mk
    touch frameworks/base/core/xsd/vts/Android.mk 2>/dev/null || echo
fi

# Send the Telegram Message

echo -e \
"
🦊 OrangeFox Recovery CI

✔️ The Build has been Triggered!

📱 Device: "${DEVICE}"
🖥 Build System: "${FOX_BRANCH}"
🌲 Logs: <a href=\"https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

# Prepare the Build Environment
source build/envsetup.sh

# Run the Extra Command
$EXTRA_CMD

# export some Basic Vars
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"

#############################################
# VENDORSETUP.SH
FDEVICE="a21s"
#set -o xtrace

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
		export ALLOW_MISSING_DEPENDENCIES=true
		export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
		export LC_ALL="C"
		export OF_VANILLA_BUILD=1
		export OF_NO_SAMSUNG_SPECIAL=0
		export FOX_DYNAMIC_SAMSUNG_FIX=1
		#export FOX_REMOVE_AAPT=1
		#export FOX_REMOVE_BASH=1
		export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"

		# Extra build vars
		#export FOX_REPLACE_BUSYBOX_PS=1
		#export FOX_REPLACE_TOOLBOX_GETPROP=1
		#export FOX_USE_TAR_BINARY=1
		#export FOX_USE_NANO_EDITOR=1
		export OF_USE_MAGISKBOOT=1
		export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
		#export FOX_RESET_SETTINGS=0
		#export FOX_DELETE_AROMAFM=1
		export OF_FL_PATH1="/tmp/flashlight"
		export OF_FL_PATH2=""
		export OF_FLASHLIGHT_ENABLE=1
		export FOX_VERSION="R12.1"
		export OF_SCREEN_H="2400"
		export OF_HIDE_NOTCH=1
		export OF_CLOCK_POS=1
		export OF_ALLOW_DISABLE_NAVBAR=0
		export OF_USE_SYSTEM_FINGERPRINT=1
		export OF_USE_TWRP_SAR_DETECT=1
		export OF_QUICK_BACKUP_LIST="/super;/boot;/vbmeta;/vbmeta_samsung;/dtbo;"
		#export FOX_USE_UNZIP_BINARY=1
		export FOX_DISABLE_APP_MANAGER=1
		#export FOX_USE_XZ_UTILS=1
		export OF_STATUS_INDENT_LEFT="48"
		export OF_STATUS_INDENT_RIGHT="48"
		export OF_STATUS_H="88"
		export OF_USE_GREEN_LED=0
		export OF_SUPPORT_PRE_FLASH_SCRIPT=1

		#R12
		export FOX_R12=1
		export FOX_BUILD_TYPE=Unstable

		# maximum permissible splash image size (in kilobytes); do *NOT* increase!
		export OF_SPLASH_MAX_SIZE=104

		# run a process after formatting data to work-around MTP issues
		export OF_RUN_POST_FORMAT_PROCESS=1

		# let's see what are our build VARs
		if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
		  export | grep "FOX" >> $FOX_BUILD_LOG_FILE
		  export | grep "OF_" >> $FOX_BUILD_LOG_FILE
		  export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
		  export | grep "TW_" >> $FOX_BUILD_LOG_FILE
		fi
fi

# Default Build Type
if [ -z "$FOX_BUILD_TYPE" ]; then
    export FOX_BUILD_TYPE="Unofficial-CI"
fi

# Default Maintainer's Name
[ -z "$OF_MAINTAINER" ] && export OF_MAINTAINER="Unknown"

# Set BRANCH_INT variable for future use
BRANCH_INT=$(echo $SYNC_BRANCH | cut -d. -f1)

# Magisk
if [[ $OF_USE_LATEST_MAGISK = "true" || $OF_USE_LATEST_MAGISK = "1" ]]; then
	echo "Using the Latest Release of Magisk..."
	export FOX_USE_SPECIFIC_MAGISK_ZIP=$("ls" ~/Magisk/Magisk*.zip)
fi

# Legacy Build Systems
if [ $BRANCH_INT -le 6 ]; then
    export OF_DISABLE_KEYMASTER2=1 # Disable Keymaster2
    export OF_LEGACY_SHAR512=1 # Fix Compilation on Legacy Build Systems
fi
#############################################

# lunch the target
if [ "$BRANCH_INT" -ge 11 ]; then
    lunch twrp_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }
else
    lunch omni_${DEVICE}-eng || { echo "ERROR: Failed to lunch the target!" && exit 1; }
fi

# Build the Code
if [ -z "$J_VAL" ]; then
    mka -j$(nproc --all) $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
elif [ "$J_VAL"="0" ]; then
    mka $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
else
    mka -j${J_VAL} $TARGET || { echo "ERROR: Failed to Build OrangeFox!" && exit 1; }
fi

# Exit
exit 0

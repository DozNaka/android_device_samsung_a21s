# TWRP for Samsung Galaxy A21s aka a21s

**Credits:** [corsicanu for original c2s source](https://github.com/corsicanu/android_device_samsung_c2s)

## Bugs 
Everything works except for the following:

- Decryption*

Decryption does not work on this device and if your device is encrypted then TWRP will be unable to view your files. To Decrypt your device, enter the terminal in TWRP and run the `multidisabler` command 

## Features
- DTB: Imported KawaKernel A12 DTB
- DTBO: Imported A217MUBUADVL2 stock recovery DTBO
- Implemented Multidisabler command
- Recovery Kernel: Slim KawaKernel A12


## Building

Make tw directory and go into it

```bash
mkdir tw; cd tw
```

Clone A21s device tree to device/samsung/a21s

```bash
git clone https://github.com/DozNaka/android_device_samsung_a21s device/samsung/a21s
```

Init TWRP AOSP 12.1 manifest repo

```bash
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
```

Sync repo and wait

```bash
repo sync
```

Begin building TWRP

```bash
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_a21s-eng; mka recoveryimage
```

Output will be in tw/out/target/product/a21s/recovery.img

## Installation

### DISCLAIMER: If this is your first time modding A21s then YOU NEED TO REFLASH STOCK ROM FIRST!

**If you do not do this then you will get KG STATE blocked and you will have to flash stock firmware anyway to fix it. So sorry linux users but you will need to use Odin (Not JOdin or heimdall) to reflash stock rom**

### Requirements: Rooted by flashing AP file via Odin that was patched using Magisk App

**To root your device with the patch AP method you do the following:**
- Install [Bifrost](https://github.com/zacharee/SamloaderKotlin/releases/latest) apk
- Download stock firmware using the Bifrost app
- Extract AP from firmware
- Install [Magisk](https://github.com/topjohnwu/Magisk/releases/latest)
- Open Magisk, press Install and then **Select and Patch a File**
- Select the AP file you have extracted from stock firmware
- Once finished patching, you will find the patched AP file in Downloads
- Move the patched AP file to your computer
- Flash the patched AP file with Odin

If you are on linux then extract the AP file and flash vbmeta and boot images with heimdall

Once you have finished this you can proceed with the methods below:

**Method 1: recovery.img**
- If you are on linux then flash recovery.img with heimdall

```bash
heimdall flash --RECOVERY recovery.img
```

### OR
- You can the TWRP app to flash the recovery.img

### OR
- You can use the dd command to flash recovery.img by placing the recovery.img in /sdcard and running these commands

```bash
su
```

```bash
dd if=/sdcard/recovery.img of=/dev/block/by-name/recovery
```

**Method 2: recovery.tar**
- Place the tar file in AP in Odin then flash


### Booting to TWRP
- Once TWRP is flashed, boot to it with volume up + power combo
- Go to Advanced -> Terminal, then you will enter the `multidisabler` command
- Reboot to recovery again
- **Format data** as you will get bootloops if you don't

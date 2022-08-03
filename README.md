# TWRP device tree for Samsung Galaxy A21s aka a21s

## Kernel source 
Available at https://github.com/DozNaka/KawaKernel-A217X

## How to build
This was tested and it's fully compatible with [minimal manifest twrp](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp).
1. Set up the build environment following instructions from [here](https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp/blob/twrp-12.1/README.md#getting-started)
2. In the root folder of cloned repo you need to clone the device tree:
```bash
git clone -b android-12.1 https://github.com/TeamWin/android_device_samsung_a21s.git device/samsung/a21s
```
3. To build:
```bash
export ALLOW_MISSING_DEPENDENCIES=true && . build/envsetup.sh && lunch twrp_a21s-eng && mka recoveryimage -j128
```

Credits: [corsicanu for original source](https://github.com/corsicanu/android_device_samsung_c2s)


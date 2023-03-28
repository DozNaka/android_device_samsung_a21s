# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Inherit from common vendor config
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/a21s/device.mk)

PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,device/samsung/a21s/recovery/root,recovery/root)

# Device identifier
PRODUCT_RELEASE_NAME := a21s
PRODUCT_DEVICE := a21s
PRODUCT_NAME := twrp_a21s
PRODUCT_BRAND := Samsung
PRODUCT_MODEL := Galaxy A21s
PRODUCT_MANUFACTURER := samsung
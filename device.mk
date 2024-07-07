# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Screen
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1600
DEVICE_RESOLUTION := 720x1600
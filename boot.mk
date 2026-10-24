# Normal-boot integration. See NORMAL_BOOT_INTEGRATION.md in the audit workspace.
$(call inherit-product, device/lge/msm8909-common/boot.mk)
$(call inherit-product, device/lge/m1-common/sensors.mk)

# Platform providers are built by CM13. Do not overwrite them with Lollipop
# libraries; see audit/PLATFORM_PROVIDER_INTEGRATION.md in the project workspace.
PRODUCT_PACKAGES += libcamera_client libxml2

PRODUCT_COPY_FILES += \
    device/lge/m1-common/rootdir/cm13/init.m1.rc:root/init.m1.rc \
    device/lge/m1-common/rootdir/cm13/init.m1.platform.rc:root/init.m1.platform.rc \
    device/lge/m1-common/rootdir/cm13/init.m1.usb.rc:root/init.m1.usb.rc \
    device/lge/m1-common/rootdir/cm13/fstab.m1:root/fstab.m1 \
    device/lge/m1-common/rootdir/cm13/ueventd.m1.rc:root/ueventd.m1.rc \
    device/lge/m1/dt.img:dt.img

# security=none cannot accept the SELinux context= FAT mount option. Select an
# otherwise identical firmware mount rule only for the no-SELinux diagnostic.
ifeq ($(TARGET_PRODUCT),cm_m1_radio_noselinux)
PRODUCT_COPY_FILES += device/lge/m1-common/rootdir/cm13/init.m1.fs.noselinux.rc:root/init.m1.fs.rc
else
PRODUCT_COPY_FILES += device/lge/m1-common/rootdir/cm13/init.m1.fs.rc:root/init.m1.fs.rc
endif

# CM13 provides init, zygote, vold, sdcard, adbd and their generic init scripts.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.zygote=zygote32 \
    persist.sys.usb.config=mtp

# Display dimensions affect resources/boot animation, not a HAL selection.
TARGET_SCREEN_HEIGHT := 854
TARGET_SCREEN_WIDTH := 480

# Normal-boot integration. See NORMAL_BOOT_INTEGRATION.md in the audit workspace.
$(call inherit-product, device/lge/msm8909-common/boot.mk)
$(call inherit-product, device/lge/m1-common/sensors.mk)
$(call inherit-product, device/lge/m1-common/heap.mk)
$(call inherit-product, device/lge/m1-common/camera.mk)
$(call inherit-product, device/lge/m1-common/gps.mk)

# CM12 builds its own core platform providers; retain the original K7 vendor
# consumers without replacing core framework libraries with stock prebuilts.
PRODUCT_PACKAGES += libcamera_client libxml2

# Stock camera HAL only; the focused radio product skips m1-vendor.mk.
PRODUCT_COPY_FILES += vendor/lge/m1/proprietary/lib/hw/camera.msm8909.so:system/lib/hw/camera.msm8909.so

PRODUCT_COPY_FILES += \
    device/lge/m1-common/rootdir/cm12/init.m1.rc:root/init.m1.rc \
    device/lge/m1-common/rootdir/cm12/init.m1.platform.rc:root/init.m1.platform.rc \
    device/lge/m1-common/rootdir/cm12/init.m1.usb.rc:root/init.m1.usb.rc \
    device/lge/m1-common/rootdir/cm12/fstab.m1:root/fstab.m1 \
    device/lge/m1-common/rootdir/cm12/ueventd.m1.rc:root/ueventd.m1.rc \
    device/lge/m1/dt.img:dt.img

# security=none cannot accept the SELinux context= FAT mount option. Select an
# otherwise identical firmware mount rule only for the no-SELinux diagnostic.
ifeq ($(TARGET_PRODUCT),cm_m1_radio_noselinux)
ifeq ($(K7_SELINUX_PERMISSIVE),true)
PRODUCT_COPY_FILES += device/lge/m1-common/rootdir/cm12/init.m1.fs.rc:root/init.m1.fs.rc
else
PRODUCT_COPY_FILES += device/lge/m1-common/rootdir/cm12/init.m1.fs.noselinux.rc:root/init.m1.fs.rc
endif
else
PRODUCT_COPY_FILES += device/lge/m1-common/rootdir/cm12/init.m1.fs.rc:root/init.m1.fs.rc
endif

# CM12 provides init, zygote, vold, sdcard, adbd and their generic init scripts.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.zygote=zygote32 \
    persist.sys.usb.config=mtp

# Display dimensions affect resources/boot animation, not a HAL selection.
TARGET_SCREEN_HEIGHT := 854
TARGET_SCREEN_WIDTH := 480

# CM12 SystemServer starts TorchService/AppWidgetService from these features.
PRODUCT_COPY_FILES += device/lge/m1-common/permissions/peridot-cm12-ui-features.xml:system/etc/permissions/peridot-cm12-ui-features.xml

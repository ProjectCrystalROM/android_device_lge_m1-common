# Original K7 HAL/sensor/tuning stack and matched stock JPEG libraries.
# CM12 supplies its own platform camera client, SensorManager and graphics.
PRODUCT_COPY_FILES += \
    device/lge/m1-common/rootdir/cm12/init.m1.camera.rc:root/init.m1.camera.rc \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

# Flash is declared by peridot-cm12-ui-features.xml for CM12 TorchService.
# Camera2 full/manual capabilities and autofocus remain unadvertised.
PRODUCT_PACKAGES += Camera2

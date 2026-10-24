# Exact K7 HAL/sensor/tuning stack with the three H631 adapters proven in live
# CM13 tests. Preserve the CM13 platform camera client and graphics libraries.
PRODUCT_COPY_FILES += \
    device/lge/m1-common/rootdir/cm13/init.m1.camera.rc:root/init.m1.camera.rc \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml

# camera2.full/manual capabilities and unqualified autofocus/flash are not
# advertised by this diagnostic selection.
PRODUCT_PACKAGES += Camera2

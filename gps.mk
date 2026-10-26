# Direct stock LG GPS HAL; K7 JNI supplies its three-pointer XTRA callback.
PRODUCT_COPY_FILES += \
    vendor/lge/m1/proprietary/lib/hw/gps.default.so:system/lib/hw/gps.msm8909.so \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml

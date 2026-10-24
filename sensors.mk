# Exact stock K7 input-based HAL. Live CM13 validation restored accelerometer
# events, screen auto-rotation and camera image orientation without a sensor daemon.
# MS33010m SHA-256: e6773ef2ce5807e5848d1cae5669d078c2e18edaca7576ec490ef3bd792ae868
# Provenance and limits: audit/motion-sensors/FINDINGS.md in the workspace.
PRODUCT_COPY_FILES += \
    vendor/lge/m1/proprietary/lib/hw/sensors.msm8909.so:system/lib/hw/sensors.msm8909.so \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml

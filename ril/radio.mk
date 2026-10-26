$(call inherit-product, device/lge/m1-common/ril/source-providers.mk)

# Matched stock daemon and RIL; CM12 Binder provides both required LG names.
PRODUCT_PACKAGES += rild libril
PRODUCT_COPY_FILES += \
    device/lge/m1-common/ril/init.m1.radio.rc:root/init.m1.radio.rc \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/vendor/lib/libril-qc-qmi-1.so \
    ro.telephony.default_network=9 \
    ro.use_data_netmgrd=true \
    persist.radio.apm_sim_not_pwdn=1 \
    ro.telephony.call_ring.multiple=false

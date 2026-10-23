# Focused wireless integration for the experimental radio products.  The
# legacy m1.mk contains unrelated HAL and media selections and is not inherited.

PRODUCT_PACKAGES += \
    libwpa_client \
    wcnss_service \
    wpa_supplicant

# These K7 files are byte-identical to the archived stock-system copies.  The
# WCNSS platform driver requests the _boot.bin name exactly; omitting it made
# the firmware userspace fallback return -ENOMEM and led to a watchdog panic.
# Keep the non-boot copy available to Prima while the stock data/persist NV
# provisioning path is investigated separately.  The existing vendor rule
# remains the sole owner of WCNSS_cfg.dat.
PRODUCT_COPY_FILES += \
    vendor/lge/m1/proprietary/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
    device/lge/m1-common/configs/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/lge/m1-common/configs/WCNSS_qcom_wlan_nv.bin:system/etc/wifi/WCNSS_qcom_wlan_nv.bin \
    device/lge/m1-common/configs/WCNSS_qcom_wlan_nv.bin:system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin \
    device/lge/m1-common/configs/WCNSS_qcom_wlan_nv.bin:system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_boot.bin \
    device/lge/m1-common/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    device/lge/m1-common/wifi/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf \
    device/lge/m1-common/wifi/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    device/lge/m1-common/wifi/WCNSS_qcom_cfg.ini:system/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    device/lge/m1-common/rootdir/cm13/init.m1.wireless.rc:root/init.m1.wireless.rc

PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=smd \
    ro.disableWifiApFirmwareReload=true \
    wifi.interface=wlan0

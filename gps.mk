# Preserve the stock modem-facing GPS implementation; adapt only its XTRA
# callback boundary to CM13. Provenance: audit/gps/FINDINGS.md in workspace.
PRODUCT_PACKAGES += gps.msm8909
PRODUCT_COPY_FILES += \
    vendor/lge/m1/proprietary/lib/hw/gps.default.so:system/lib/hw/gps.k7-stock.so \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml

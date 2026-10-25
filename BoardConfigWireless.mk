# Focused K7 WCNSS/Prima and Bluetooth build selection.  Keep this separate
# from BoardConfigCommon.mk so the diagnostic product does not inherit the
# legacy camera, media, recovery, or boot settings in that file.

# Wi-Fi
BOARD_HAS_QCOM_WLAN := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
TARGET_USES_WCNSS_CTRL := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WPA_SUPPLICANT_VERSION := VER_0_8_X
WPA_SUPPLICANT_CONF_TEMPLATE := device/lge/m1-common/configs/wpa_supplicant.conf

# The source kernel has the Pronto WLAN driver built in, so no wlan.ko path is
# declared.  Do not enable TARGET_USES_QCOM_WCNSS_QMI until a K7-backed MAC
# provider is selected; CM's OSS service otherwise dlopens an absent shim.

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BLUETOOTH_HCI_USE_MCT := true
# Hand the selected persistent identity to the retained stock helper.
BOARD_BLUETOOTH_PUBLISH_LOCAL_ADDRESS := true

# Keep the already staged K7 vendor library.  BOARD_HAVE_BLUETOOTH_QCOM would
# replace it with a source-built libbt-vendor and is intentionally not selected.

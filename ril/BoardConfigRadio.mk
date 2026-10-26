# Matched proprietary daemon + LG libril; do not build CM's SAP daemon/library.
BOARD_PROVIDES_RILD := true
BOARD_PROVIDES_LIBRIL := true
M1_BUILD_RADIO_COMPAT := false

# A property file preserves the space in rild.libargs; product word lists do not.
TARGET_SYSTEM_PROP += device/lge/m1-common/ril/radio.prop

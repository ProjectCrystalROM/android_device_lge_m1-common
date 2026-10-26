# Stock-backed m1 boot layout; see audit/stock-image-report.json in the workspace.
TARGET_BOOTLOADER_BOARD_NAME := m1
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk androidboot.hardware=m1
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x02000000
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x02000000 --tags_offset 0x00000100
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2524971008
BOARD_USERDATAIMAGE_PARTITION_SIZE := 4848615424
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_FLASH_BLOCK_SIZE := 131072

# CM12 packages the stock DT in boot/recovery and target-files/OTA metadata.
# Apply the platform/cm12.1 build patch to preserve this prebuilt DT.
BOARD_KERNEL_SEPARATED_DT := true
# This DT is archived/prebuilt; suppress dtbTool regeneration from kernel sources.
BOARD_KERNEL_PREBUILT_DT := true
BOARD_SEPOLICY_DIRS += device/lge/m1-common/sepolicy/boot

# CM owns battery_fail.png; retain only AOSP's distinct fallback battery scale.
BOARD_HEALTHD_CUSTOM_CHARGER_RES := device/lge/m1-common/rootdir/cm12/charger

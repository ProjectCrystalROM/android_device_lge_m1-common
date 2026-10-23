# Early-boot diagnostic only. Generic LSM selection disables SELinux in the
# kernel even when CONFIG_SECURITY_SELINUX_BOOTPARAM was not enabled.
# The matching CM userdebug/eng flag skips userspace policy initialization.
# Policy 30 is still built normally for the later compatible-kernel profile.
BOARD_KERNEL_CMDLINE += security=none androidboot.selinux=disabled

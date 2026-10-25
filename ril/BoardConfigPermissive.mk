# Explicit policy probes; default diagnostic boot stays SELinux-disabled.
ifneq ($(TARGET_PRODUCT),cm_m1_radio_noselinux)
$(error K7 permissive probe requires cm_m1_radio_noselinux)
endif
ifeq ($(K7_SELINUX_ENFORCING),true)
BOARD_KERNEL_CMDLINE += security=selinux enforcing=1 androidboot.selinux=enforcing
else
BOARD_KERNEL_CMDLINE += security=selinux enforcing=0 androidboot.selinux=permissive
endif

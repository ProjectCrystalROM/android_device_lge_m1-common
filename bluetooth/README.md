# Stock K7 Bluetooth address handoff

BoardConfigWireless.mk enables BOARD_BLUETOOTH_PUBLISH_LOCAL_ADDRESS. This
requires the accompanying system/bt patch; the retained stock vendor library
and hci_qcomm_init consume persist.service.bdroid.bdaddr separately from the
address passed to vendor init. Without the handoff the helper randomizes the
controller identity despite an existing saved adapter address/bond.

Patch base: CyanogenMod/android_system_bt cm-13.0,
ccde045431d38d4828412149f067631487f8025f.
Local stack milestone: f9fbab5 (bringup/cm13-m1). Apply the patch with git am in
system/bt when reproducing from that base. The active build source already
contains the commit; do not apply it twice. An owner system-bt fork was not
available when recording this milestone, so the exact patch is published here.

Qualified with full enforcing ZIP b82ead41cfa952b21f88f4e5f337c5edd41431602ed0c39ba2c6cdbcf037f967.
Owner confirms automatic headset connection before unlock on two boots; logs
show stack publication and stock-helper/controller address agree and retain
the existing saved identity. No NV rewrite, bond reset or policy relaxation.
Only the source-built bluetooth.default module changes, plus generated metadata.
Other profiles/headsets and broader endurance remain outside this observation.

# LG K7 CM13 common device tree

**Status, 2026-10-24: integrated into a ROM that builds and boots on MS330.**
This branch is `resurrection/cm13-static-audit`. Use it with the matching
[product bring-up branch](https://github.com/airi-kozume/cyanogenmod_device_lge_m1/tree/bringup/cm13-m1),
[vendor branch](https://github.com/airi-kozume/proprietary_vendor_lge_m1/tree/bringup/cm13-m1)
and [kernel branch](https://github.com/airi-kozume/cyanogenmod_kernel_lge_m1/tree/bringup/cm13-m1).
The product README contains the detailed, current validation matrix.

## Selected integration

- Focused boot, radio and wireless init fragments, preserving source-built
  CM13 platform providers rather than importing all legacy LG services.
- WCNSS boot ordering, firmware-reload handling and wireless configuration.
- Stock-identity camera daemon startup and data-directory creation.
- Camera/sensor feature declarations and stock-sized Dalvik heap settings.
- Stock K7 recording profiles and a minimal Qualcomm AVC encoder declaration,
  retaining the existing software decoder includes.
- Targeted ARM32 Parcel compatibility bridges for the selected stock RIL.

## Confirmed on the device

The combined port boots through a clean installation to the launcher. Display,
touch/navigation, Wi-Fi Internet access, Bluetooth pairing/A2DP and speaker
audio work. Both cameras preview and save photos; rear 720p H.264/AAC recording
saves and plays. Rotation and saved-photo orientation work. SIM detection,
IMEI and baseband are established.

WebView107 login, upstream microG Services/Companion self-check and the corrected
no-screen Provision path are confirmed in the matching product/vendor setup.
GsfProxy's missing self-check entry was resolved by a separate upstream APK
installation; its inclusion in a future ROM is now selected in source.

## Open work and scope

The qualified product is `cm_m1_radio_noselinux-userdebug`. SELinux policy/kernel
integration remains unresolved; successful diagnostic boot does not establish
the SELinux-enabled product. Live cellular data/calls/SMS await an active SIM.
GPS, suspend/endurance, front video and call/HFP behavior need further testing.
Other K7 variants are not qualified.

The full CM13 checkout, platform changes and build/audit tooling live outside
this repository. Detailed evidence is retained in the bring-up workspace's
`audit/` directory; it is not part of this repository. Preserve the qualified
wireless/camera rollback packages when changing individual subsystems.

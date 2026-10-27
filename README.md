# CM12.1 hardware-qualified MS330 baseline — 2026-10-26

The cm12.1 branch is separate from CM13. Owner validated the signed DSI-fix
ROM: normal boot, home screen and sleep/wake; Wi-Fi/browser access; Bluetooth
pairing, notification audio and reboot persistence; front/rear photo and video
capture; Gallery recorded-video playback with audio; GPS (~20 satellites, ~6m
reported accuracy); GSM SIM recognition; LTE browser access and YouTube
streaming after reboot with the correct nxtgenphone APN.

The missing stock /system/etc/data/dsi_config.xml was the shared CM12/CM13 data
initialization blocker. Vendor source18bc953 restores it; CM13 live test and
CM12 signed-ROM runtime test passed. Source APN defaults were edited later and
are not part of this hardware-qualified ROM; saved owner APN was used.

CM12 Cyanogen recovery is BROKEN: Finding recovery package... followed by
bootloader. TWRP is the intended installed recovery. Full OTA preserves it;
separate CM recovery retest failed and must not be presented as working.
SIM changes require reboot; CSIM and voice/VoLTE remain outside this profile.
MicroG account/push and the WebView95 candidate are not newly qualified.

Reproduction uses Java7/Trusty; kernel/lge/m1-custom points to the independent
custom kernel on cm12.1, published in airi-kozume/cyanogenmod_kernel_lge_m1
cm12.1 (different kernel history from the CM13 branch). Original custom kernel
source remains unchanged. Common-tree platform/cm12.1 contains exact platform
patches, hashes and source pins, including Gallery and libc changes.

Hardware-qualified ROM SHA256:
8ba5854e5c7b92757cd652fcd750d85e9430afe77f27ac5ee4a43a03a14d9e26
ROM filename: cm-12.1-20261027-UNOFFICIAL-m1-peridot-data-fix.zip
(UTC build date; local qualification October26.) Offline release-signature,
81 APK, 17 kernel-module, DSI ext4 metadata, OTA block and recovery-preservation
checks passed. Keys, generated images and private raw logs are not published.

Earlier entries below retain their original chronological status.

# CM12.1 common-device branch — experimental

Android 5.1.1/API22 integration is under build validation. Use the platform
patches in [platform/cm12.1](platform/cm12.1/README.md). The CM13 patches in
the parent platform/bluetooth directories are historical references here.

This branch selects direct stock GPS with a K7 JNI callback correction, stock
SensorManager-compatible camera plugin, and no RIL compatibility shim. The
separate `rootdir/cm12` is the active ramdisk. CM13 hardware acceptance does
not establish CM12 runtime acceptance. Earlier documentation follows.

---

# LG K7 CM13 common device tree

**2026-10-25: hardware-qualified in the enforcing `cm_m1-userdebug` ROM on
MetroPCS MS330.** Branch: `resurrection/cm13-static-audit`.

Use the matching [product](https://github.com/airi-kozume/cyanogenmod_device_lge_m1/tree/bringup/cm13-m1),
[vendor](https://github.com/airi-kozume/proprietary_vendor_lge_m1/tree/bringup/cm13-m1),
[SoC common](https://github.com/airi-kozume/android_device_lge_msm8909-common/tree/bringup/cm13-m1)
and [kernel](https://github.com/airi-kozume/cyanogenmod_kernel_lge_m1/tree/bringup/cm13-m1)
branches. The product README is the full validation matrix.

## Selected integration

- Focused boot/radio/wireless init, preserving CM13 platform providers.
- Explicit Wi-Fi HAL/config dependencies, WCNSS startup and firmware ordering.
- Stable Bluetooth address handoff and persistent automatic reconnect.
- Stock-identity camera daemon; matched H631 sensor/JPEG adapters, stock sensor
  HAL, heap sizing and camera/sensor feature declarations.
- Stock Venus firmware and recording profiles; Qualcomm AVC encode/decode
  registration for front/rear video saving and stock-player hardware playback.
- Stock GPS HAL with a narrow CM13 XTRA callback adapter; see [GPS notes](gps/README.md).
- Correct LG USB identities for simplified MTP/PTP functions, including ADB.
- Reviewed SELinux rules and ARM32 Parcel compatibility for the retained RIL.

## Confirmed and remaining

Boot, display, touch/navigation, Wi-Fi persistence, Bluetooth bonds/reconnect/
A2DP, media audio, front/rear photos/video with sound, flash, rotation, hardware
H.264 playback, all four MTP/PTP±ADB combinations and GPS/Maps work. Overnight
idle shows no observed problems. Backup & reset and the matched microG/WebView
integration work. SELinux boots enforcing with existing userdebug exceptions.

Remaining owner acceptance: active-SIM cellular data and normal-use battery
endurance. SIM detection/IMEI/baseband already work. Calls/call audio are outside
scope because VoLTE is unsupported and local networks require it. OTG is
unsupported. Detailed GPS satellite-status/assistance behavior and longer
workloads remain developer follow-ups. Other variants are unqualified.

The stable-address Bluetooth change also requires the reviewed platform patch
[and application notes](bluetooth/README.md). Platform framework changes,
Trusty/Java 7 build setup, package audit tools and checkpoint ZIPs live in the
surrounding workspace. Preserve rollback packages; do not publish private logs.

Required microG and Bluetooth platform patches are published with exact base
commits in [platform notes](platform/README.md).

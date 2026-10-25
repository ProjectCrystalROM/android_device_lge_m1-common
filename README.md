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

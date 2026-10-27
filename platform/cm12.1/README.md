# CM12.1 platform changes

Hardware-qualified LG K7 MS330 Android 5.1.1/API22 integration. CM13 patches in
the parent directory belong to a separate Android version. patches.json records
exact upstream bases and patch SHA256; apply inside each listed project using
git apply --check followed by git apply. Do not reapply to patched worktrees.

Exports cover microG signature reporting/location binding, direct stock GPS
callbacks, existing LG Binder exports, Bluetooth address handoff, boot image DT
selection, RIL ownership, Cronet libc entry points with unloaded-library fork
handler cleanup, Gallery video title null guards, and installed-recovery
preservation during full OTA generation. Device flags scope LG-specific paths.

Owner confirms home screen, sleep/wake, Wi-Fi, Bluetooth audio/pairing and reboot
persistence, both cameras for photos/video, recorded-video playback with audio,
GPS (~20 satellites/~6m reported accuracy), GSM SIM recognition, and LTE browser
access plus YouTube streaming after reboot. DSI XML fix lives in vendor/lge/m1.
These observations do not qualify every microG service, format or hardware path.

Keep ROM WebView for this qualified baseline. WebView95 candidate and newly
changed APN defaults have separate pending integration/build tests. CM12 recovery
is BROKEN: Finding recovery package... then bootloader; use TWRP. Recovery
preservation is required even though the separate recovery image remains broken.

Use Java7/Python2/Trusty and the independent kernel/lge/m1-custom cm12.1 source,
not the CM13-adapted kernel. Host kernel revision staging uses .scmversion to
avoid old Trusty Git's lack of linked-worktree support. Private signing keys,
raw logs, subscriber/location evidence and generated images are not included.

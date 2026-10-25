# K7 radio Parcel bridges

**Current status, 2026-10-25:** the ARM32 bridges compile in the full CM13 build
and are part of the boot-tested radio integration. SIM detection, IMEI and
baseband are confirmed. Active-SIM cellular data remains unqualified. Calls/call audio are outside
scope: VoLTE is unsupported and local networks require VoLTE. The earlier “sources absent / not built” notes are obsolete.

The two bridges address exact legacy Parcel names imported by K7 LG libril.so.
They use the selected CM13 Binder headers and forward the object and every
argument. They do not invent SAP, RIL_register_socket or RIL_onRequestAck entry
points, or establish general Binder ABI compatibility.

Names and the original build-rule approach come from the Apache-2.0 H631 source
`touchpro/android_device_lge_msm8916-common-lineageos13`, historical candidate
84ab091b9eb7 (`liblge/lge_ril.cpp`, `Android.mk`). The wrappers were rewritten to
explicitly declare and forward all method arguments. Source hashes/provenance
are retained in the workspace's `audit/abi-candidates/h631/sources`.

The modules are gated by TARGET_DEVICE=m1, TARGET_ARCH=arm and
M1_BUILD_RADIO_COMPAT=true. The standard cm_m1 and focused legacy radio products enable the mapping for
`/system/lib/libril.so`.
Matched stock K7 rild/libril are retained, with CM core owning ril-daemon/sockets.

## Validation boundaries

The ARM32 bridge and native test compile with the pinned CM13 toolchain.
Actual ELF exports/imports are checked. Four serialization tests pass under
QEMU Cortex-A7 with `M1_PARCEL_TEST_SERIALIZATION_ONLY=1`. That mode retains its
test Parcel objects until exit because destruction initializes `/dev/binder`.
It exercises real encoding/status behavior; it does not test Binder IPC,
object destruction or cellular service. With the variable unset, Android tests
still destroy their objects. Full Android-native test execution is not claimed.

The standard cm_m1 ROM now boots SELinux enforcing after the reviewed kernel
compatibility backports and device-policy fixes; existing userdebug domain
exceptions remain. This supersedes the earlier disabled-policy status. Detailed evidence is
in workspace `audit/TRUSTY_NATIVE_VALIDATION.md` and the radio audit reports.

# K7 radio Parcel bridges (experimental product)

These two ARM32 bridges address the exact legacy Parcel names imported by the
K7 LG libril.so. They use the selected CM13 Binder header and explicitly forward
the object and every argument. No RIL_register_socket or RIL_onRequestAck stub is
provided. This does not implement SAP, change a RIL protocol or certify Binder ABI.

The names and original build-rule approach come from the Apache-2.0 H631 source:
touchpro/android_device_lge_msm8916-common-lineageos13, historical candidate
84ab091b9eb7 (liblge/lge_ril.cpp and Android.mk). Audit provenance retains the full
commit and source hashes in audit/abi-candidates/h631/sources. The wrappers have
been rewritten to declare and forward all method arguments explicitly.

The module is gated by TARGET_DEVICE=m1, TARGET_ARCH=arm and
M1_BUILD_RADIO_COMPAT=true. The experimental cm_m1_radio product enables and
packages it, and exports a targeted LD_SHIM_LIBS mapping for /system/lib/libril.so.
The default cm_m1 product leaves it unselected. This is source integration;
neither product is a claim of successful radio operation.

Build libm1_ril_compat and m1_ril_compat_test in a complete CM13 source tree.
Inspect the compiled ARM ELF's exact exports/imports, then run the native test on
a compatible Android ARM32 target. The tests exercise real Parcel encoding,
embedded UTF-16 nulls, object/output arguments, position changes and failure
propagation. They have not been built or run. The Linux Trusty chroot now runs
Java 7/Python 2.7/GCC 4.8, but the complete Android build sources are still absent.

The radio product uses the matched stock K7 daemon and LG libril. CM's source
providers are suppressed by BOARD_PROVIDES_RILD/BOARD_PROVIDES_LIBRIL; no SAP
entry point is invented. The existing CM core owns ril-daemon and its sockets.
See audit/RADIO_PROFILE_INTEGRATION.md in the project workspace for boundaries,
startup inputs, checks and outstanding qualification.

Current validation (see audit/TRUSTY_NATIVE_VALIDATION.md): the ARM32 bridge and
native tests compile in Trusty with the pinned CM13 platform. Both legacy exports
and modern imports were checked in the real ELF. All four serialization tests
pass under QEMU Cortex-A7 with M1_PARCEL_TEST_SERIALIZATION_ONLY=1. That explicit
mode keeps a handful of test Parcel objects alive until process exit because
CM13 destruction initializes /dev/binder even for empty Parcels. It tests real
encoding/status behavior without replacing Binder or faking driver responses;
it does not exercise object destruction, Binder IPC or radio operation. With the
environment variable unset, Android test runs still destroy their Parcels.

A separate boot blocker remains: the live kernel supports SELinux policy version
28 while this CM13 policy requires version 30 ioctl rules. Compilation as version
28 fails; no rules were stripped and no permissive radio domains were introduced.

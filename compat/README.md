# K7 microG libc contract tests

Build only when requested: `make k7_microg_libc_test`. It is not selected as a
ROM system package. Run with ARM QEMU against the built system prefix and
LD_LIBRARY_PATH=/system/lib:/system/priv-app/GmsCore/lib/arm.

Checks GNU strerror return/errno behavior, fortified pread data and file offset,
expected aborts on both buffer/count overflow, atfork callback ordering, selective
DSO finalize/unregister, legacy pthread_atfork, and the exact pinned Cronet JNI
library loading/unloading followed by another fork.

Both SIGABRT children are deliberate fortify tests. A zero exit and all four PASS
lines are required. These tests do not validate Android services, network traffic
or phone hardware. The workspace audit/cm12-port/bionic-qemu.json records the
actual tested library/binary hashes.

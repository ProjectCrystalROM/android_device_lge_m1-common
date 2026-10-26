# CM12.1 platform changes

Experimental LG K7 Android 5.1.1 integration. These are CM12.1 patches; the
CM13 patches in the parent directory are historical references for this branch.

`patches.json` records each exact upstream base and patch SHA-256. Apply each
patch inside its listed project with `git apply --check` followed by `git apply`.
Already-patched local CM12 worktrees must not apply them again.

Includes supplied signature reporting and microG location binding; existing LG
Binder export selection; direct stock GPS callback storage extension; Bluetooth
address handoff; prebuilt DT selection; stock-rild ownership; and real libc
entry points with DSO-aware fork cleanup for bundled Cronet. Keep the ROM WebView. The K7 product sets
board flags so LG Binder and GPS behavior is scoped to this device.

These exported changes are under build validation. A clean build is not proof
of hardware or microG runtime compatibility. Original CM13 sources/releases
remain separate. The kernel uses its inherited cm12.1 branch; the host launcher
records the real kernel Git revision in its supported .scmversion input because
Trusty Git and this old kernel predate linked-worktree support.

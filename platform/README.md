# Platform changes required by this device integration

The component repositories do not replace a full CM13 checkout. Apply these
reviewed platform changes as well; skip a patch if its commit is already present.

## microG permission support

`frameworks-base-microg.patch` exports the exact tested framework commit
57d34403e3f8de13b5c9165de222e23eb92312ab from branch
microg/cm13-permission-support. Base:
4b4e8b379c8f57895fda5ee14528b72910dfb414 in CyanogenMod/android_frameworks_base.
Apply with `git am /path/to/frameworks-base-microg.patch` inside frameworks/base.
It adds permission-controlled signature reporting; it is not a blanket grant.
Owner microG self-check/login results qualify the matching framework and APKs.
The upstream-only local remote is not an owner publication branch; this exact
format-patch is the reproducible published form of the local commit.

## Stable Bluetooth address

Apply `../bluetooth/system-bt-address-handoff.patch` inside system/bt. Its
base and exact tested commit are documented in ../bluetooth/README.md.
Both local platform worktrees already contain the changes and are clean.
Do not apply either patch twice. Raw device logs, crash dumps and credentials
are not needed to apply these source patches and are not published.

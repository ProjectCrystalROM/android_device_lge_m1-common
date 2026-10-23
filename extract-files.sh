#!/bin/bash
# Offline extraction only. No implicit device access and no blanket blob deletion.
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ANDROID_ROOT=$(cd -- "$SCRIPT_DIR/../../.." && pwd)
if [[ $# -lt 1 || $# -gt 2 || ! -d "$1/system" ]]; then
    echo "Usage: $0 EXPANDED_ROM_ROOT [vendor/lge/m1 directory]" >&2
    echo 'EXPANDED_ROM_ROOT must contain system/. Hardware extraction is not automatic.' >&2
    exit 1
fi
ROM_ROOT=$(cd -- "$1" && pwd)
VENDOR_DIR=${2:-$ANDROID_ROOT/vendor/lge/m1}
missing=0
while IFS= read -r entry; do
    entry=${entry%%#*}
    entry=$(printf '%s' "$entry" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -z "$entry" ]] && continue
    if [[ "$entry" == -* || "$entry" == /* || "$entry" == *..* ]]; then
        echo "Unsupported or unsafe blob entry: $entry" >&2
        exit 1
    fi
    source=${entry%%:*}
    destination=${entry#*:}
    input="$ROM_ROOT/system/$source"
    [[ -f "$input" ]] || input="$ROM_ROOT/system/$destination"
    if [[ ! -f "$input" ]]; then
        echo "Missing ROM source: $source (also tried $destination)" >&2
        missing=1
        continue
    fi
    output="$VENDOR_DIR/proprietary/$source"
    mkdir -p -- "$(dirname -- "$output")"
    cp -- "$input" "$output"
done < "$SCRIPT_DIR/proprietary-blobs.txt"
if [[ $missing != 0 ]]; then
    echo 'Extraction incomplete; existing unrelated blobs and makefiles were preserved.' >&2
    exit 1
fi
bash "$SCRIPT_DIR/setup-makefiles.sh" "$VENDOR_DIR"

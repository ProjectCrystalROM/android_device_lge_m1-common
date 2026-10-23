# Charger resource ownership

`battery_scale.png` is an unchanged copy from CM13 system/core/healthd/images
at system/core commit 420d162484acf9c30693a651702eee5864cf14a1.
It preserves the AOSP fallback scale. CM vendor charger owns battery_fail.png
and cm_battery_scale.png, avoiding two recipes for the failure image.
This resource choice has not been tested in off-mode charging on the phone.

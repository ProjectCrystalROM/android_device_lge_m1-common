# K7 GPS integration

CM13 uses the exact MS33010m GPS HAL (SHA256
1f2643066a3e2ea84a51494b6d108049980ff002a2d5e6354d0f03698efd768c),
renamed gps.k7-stock.so. gps.msm8909 loads it and adapts only XTRA callbacks.
LG's HAL passes the caller's callbacks through to loc_eng_xtra_init, which reads
three pointers. CM13 provides two; its adjacent AGPS callback can otherwise be
called with an XTRA URL. The adapter supplies a process-lifetime third NULL
pointer, leaving other functions and extension interfaces unchanged.

The modem-facing libloc*, libgps.utils and platform providers stay unchanged.
A GPS fix was observed in the approved temporary runtime test. Owner confirms Maps location on the persistent ROM and 20 visible satellites.
GPS Toolbox reports zero full fixes indoors; fix-status reporting remains
unqualified. GPS registration alone is not proof of satellite fix
or assistance compatibility. Workspace audit/gps holds private runtime evidence;
never publish coordinates/raw logs. No GPS-specific SELinux rule added.

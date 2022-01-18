- enable root login via password in sshd_config?
- (or) set root login disable
- add a 'we' user

Compatibility:
- BR 2019.08... (fixed)
BR2_PACKAGE_FFTW_SINGLE=y (instead of BR2_PACKAGE_FFTW_PRECISION_SINGLE=y)

Figure out how to deal with dtbo files properly. Currently testing out this hack:
http://lists.busybox.net/pipermail/buildroot/2017-January/181681.html

..then renaming the files to dtbo and moving them into place

Switch to latest kernel w/ overrideable overlays

#!/usr/bin/env bash
set -e

arch="$(dpkg --print-architecture)"

# If host architecture is i386 or amd64, run RadarBox through armhf software emulation.
if [ "$arch" = "i386" ] || [ "$arch" = "amd64" ]; then 
	/usr/bin/qemu-arm-static /usr/bin/rbfeeder --showkey --no-start
else 
	/usr/bin/rbfeeder --showkey --no-start
fi

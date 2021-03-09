#!/usr/bin/env bash
set -e

# Import our key to apt-key
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 1D043681

# Move old source
/bin/rm -f /etc/apt/sources.list.d/rb24.list

# Create a new debian repository source file
echo 'deb https://apt.rb24.com/ buster main' > /etc/apt/sources.list.d/rb24.list

arch="$(dpkg --print-architecture)"
echo System Architecture: $arch

# If host architecture is i386 or amd64, install armhf-version of RadarBox and run it throug software emulation.
if [ "$arch" = "i386" ] || [ "$arch" = "amd64" ]; then 
	dpkg --add-architecture armhf
		apt update && apt install -y --no-install-recommends \
	    rbfeeder:armhf qemu-user qemu-user-static binfmt-support libc6-armhf-cross
else 
	apt update && apt install -y --no-install-recommends \
	    rbfeeder
fi

apt clean && apt autoclean && apt autoremove && \
	rm -rf /var/lib/apt/lists/*
#!/bin/bash -eux
echo "Removing development packages and cleaning up DNF data"
dnf -y remove gcc cpp gc kernel-devel kernel-headers glibc-devel elfutils-libelf-devel glibc-headers kernel-devel kernel-headers
dnf -y autoremove
dnf -y clean all --enablerepo=\*

# Avoid 150 meg firmware package we don't need
echo "Removing extra packages"
dnf -y remove linux-firmware

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# Remove any non-loopback network configs
find /etc/sysconfig/network-scripts -name "ifcfg-*" -not -name "ifcfg-lo" -exec rm -f {} \;

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts
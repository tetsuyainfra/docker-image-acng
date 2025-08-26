#!/bin/sh

set -xe

echo "Starting apt-cacher-ng..."
echo "CMD: $@"

chown apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng
chown apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng

if [ -n "${TOP_MIRROR_DEBIAN}" ]; then
    echo "${TOP_MIRROR_DEBIAN}" > /etc/apt-cacher-ng/backends_debian
fi

if [ -n "${TOP_MIRROR_UBUNTU}" ]; then
    echo "${TOP_MIRROR_UBUNTU}" > /etc/apt-cacher-ng/backends_ubuntu
fi

touch /var/log/apt-cacher-ng/apt-cacher.{dbg,err,log}
chown apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng/*
tail -f /var/log/apt-cacher-ng/apt-cacher.dbg &
tail -f /var/log/apt-cacher-ng/apt-cacher.err &
tail -f /var/log/apt-cacher-ng/apt-cacher.log &


# 必要そうなパターン
exec /usr/sbin/apt-cacher-ng -c /etc/apt-cacher-ng -v foreground=1
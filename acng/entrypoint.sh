#!/bin/sh

set -xe

echo "Starting apt-cacher-ng..."
echo "CMD: $@"

chown apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng
chown apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng

touch /var/log/apt-cacher-ng/apt-cacher.{dbg,err,log}
chown apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng/*
tail -f /var/log/apt-cacher-ng/apt-cacher.dbg &
tail -f /var/log/apt-cacher-ng/apt-cacher.err &
tail -f /var/log/apt-cacher-ng/apt-cacher.log &


# 必要そうなパターン
exec /usr/sbin/apt-cacher-ng -c /etc/apt-cacher-ng -v foreground=1
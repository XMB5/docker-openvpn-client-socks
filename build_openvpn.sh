#!/bin/bash

set -e

apk add build-base openssl-dev lzo lzo-dev linux-pam-dev linux-headers iproute2 lz4-dev lz4-libs
wget -O- https://swupdate.openvpn.org/community/releases/openvpn-2.4.8.tar.gz | tar xfz -
cd /openvpn-2.4.8
for FILENAME in 02-tunnelblick-openvpn_xorpatch-a.diff 03-tunnelblick-openvpn_xorpatch-b.diff 04-tunnelblick-openvpn_xorpatch-c.diff 05-tunnelblick-openvpn_xorpatch-d.diff 06-tunnelblick-openvpn_xorpatch-e.diff; do
    wget "https://raw.githubusercontent.com/Tunnelblick/Tunnelblick/6c0791234b2cc3decccefbf6d81ad89a99542046/third_party/sources/openvpn/openvpn-2.4.8/patches/$FILENAME" -O- | patch -p1
done
./configure
make "-j$(nproc)"
make install

apk del build-base openssl-dev lzo-dev linux-pam-dev linux-headers lz4-dev
cd /
rm -rf /openvpn-2.4.8 /build_openvpn.sh

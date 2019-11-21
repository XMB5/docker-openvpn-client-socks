#!/bin/bash

cd /userdir
exec openvpn --config "$OPENVPN_CONFIG" --dev tun0 --script-security 2 --mode p2p --up /up.sh --tls-verify /bin/true --ipchange /bin/true --route-up /bin/true --route-pre-down /bin/true --down /bin/true "$@"

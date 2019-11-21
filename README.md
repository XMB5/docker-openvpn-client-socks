
# OpenVPN-client  
  
This is a docker image of an OpenVPN client tied to a SOCKS proxy server.  It is  
useful to isolate network changes (so the host is not affected by the modified  
routing).  
  
This supports directory style (where the certificates are not bundled together in one `.ovpn` file) and those that contains `update-resolv-conf`  
  
(For the same thing in WireGuard, see [kizzx2/docker-wireguard-socks-proxy](https://github.com/kizzx2/docker-wireguard-socks-proxy))  
  
## Why?  
  
This is arguably the easiest way to achieve "app based" routing. For example, you may only want certain applications to go through your OpenVPN tunnel while the rest of your system should go through the default gateway. You can also achieve "domain name based" routing by using a [PAC file](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file) that most browsers support.  
  
## Usage  
  
```bash  
docker run -it --rm --device=/dev/net/tun --cap-add=NET_ADMIN \  
 --volume /your/openvpn/directory/:/userdir:ro -e 'OPENVPN_CONFIG=path/to/config.conf' \ -p 1080:1080 xmb5/openvpn-client-socks
 ```  
`OPENVPN_CONFIG` is a path that points to the OpenVPN config to use, relative to the directory mounted to /userdir.  

For example, in the following directory tree  
```  
my_vpn_configs  
├───united_states  
│      us.conf  
│      ca.crt  
└───canada  
       canada.conf
 ```  
To connect to the US and to have the proxy listen on port 1234, run  
```bash  
docker run -it --rm --device=/dev/net/tun --cap-add=NET_ADMIN \  
 --volume my_vpn_configs:/userdir:ro -e 'OPENVPN_CONFIG=united_states/us.conf' \
 -p 1234:1080 xmb5/openvpn-client-socks  
```  
  
Then connect to SOCKS proxy through through `localhost:1234` or whatever port 1080 is mapped to. For example:  
  
```bash  
curl --proxy socks5h://localhost:1234 ipinfo.io  
```  
  
## HTTP Proxy  
  
You can easily convert this to an HTTP proxy using [http-proxy-to-socks](https://github.com/oyyd/http-proxy-to-socks), e.g.  
  
hpts -s 127.0.0.1:1080 -p 8080

## Notes
- All user-defined scripts (`--up`, `--down`, `--route-up`, etc) are disabled.
	- Certain OpenVPN configs require`update-resolv-conf`, but since scripts are disabled, this command won't run
	- Therefore, DNS requests might leak or DNS might not work at all
- Add extra OpenVPN options by passing them as the command, for example `docker run [...] xmb5/openvpn-client-socks --verb 4` for extra debug information
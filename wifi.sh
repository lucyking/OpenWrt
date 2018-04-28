uci set wireless.@wifi-device[0].disabled=0
uci commit wireless
wifi

uci set network.wwan=interface
uci set network.wwan.proto=dhcp
uci commit network

uci set wireless.radio0.channel=11	
uci set wireless.@wifi-iface[0].network=wwan
uci set wireless.@wifi-iface[0].mode=sta
uci set wireless.@wifi-iface[0].ssid=TP-LINK_PocketAP_D5D1B8 	
uci set wireless.@wifi-iface[0].encryption=wpa2-psk
uci set wireless.@wifi-iface[0].key=12345678
uci set wireless.@wifi-iface[0].macaddr="00:60:2F$(dd bs=1 count=3 if=/dev/random 2>/dev/null |hexdump -v -e '/1 ":%02X"')"
uci commit wireless
wifi down
wifi

uci set network.lan.ipaddr=192.168.10.1
uci set network.lan.gateway=192.168.1.1
uci set network.lan.dns=8.8.8.8
uci commit network
wifi down
wifi

# May should install first.
#opkg update
#opkg install relayd
/etc/init.d/relayd enable

uci set network.stabridge=interface
uci set network.stabridge.proto=relay
uci set network.stabridge.network="lan wwan"
uci commit network

uci set dhcp.lan.ignore=1
uci commit dhcp

uci set firewall.@zone[0].forward=ACCEPT
uci set firewall.@zone[0].network="lan wwan"
uci commit firewall

#uci add wireless wifi-iface
#1. Add a new interface if it's not exist at first time, which lead to ERR:
# 	```
# 	root@OpenWrt:~# uci set wireless.@wifi-iface[1].device
# 	uci: Invalid argument
# 	```
#
#2. Run ```cat cat /etc/config/wireless``` to inspect the details.
uci set wireless.@wifi-iface[1].device=radio0
uci set wireless.@wifi-iface[1].network=lan
uci set wireless.@wifi-iface[1].mode=ap
uci set wireless.@wifi-iface[1].ssid=OPEN_WRT
uci set wireless.@wifi-iface[1].encryption=wpa2-psk
uci set wireless.@wifi-iface[1].key=lucyking
uci commit wireless
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
wifi down
wifi


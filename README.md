# OpenWrt
### 目的：
每次重启生成新的MAC 在桥接其他wifi网络时绕过MAC黑名单


### 说明：
1. 在/etc/rc.local中增加 ```/<path>/wifi.sh``` , 使开机自动执行wifi.sh脚本

2. relayd 模块安装一下
```
opkg update
opkg install relayd
```

3. 初次运行，如果出现错误：
```
root@OpenWrt:~# uci set wireless.@wifi-iface[1].device
uci: Invalid argument
```
先增加一下option:
```
uci add wireless wifi-iface
```
执行```cat cat /etc/config/wireless```查看配置详情

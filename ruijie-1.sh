#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# 复制E8820V2配置文件到编译目录
cp -R $GITHUB_WORKSPACE/patchs/E8820V2/mt7621.mk $GITHUB_WORKSPACE/openwrt/target/linux/ramips/image/mt7621.mk
cp -R $GITHUB_WORKSPACE/patchs/E8820V2/mt7621_zte_e8820v2.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7621_zte_e8820v2.dts
cp -R $GITHUB_WORKSPACE/patchs/E8820V2/01_leds $GITHUB_WORKSPACE/openwrt/target/linux/ramips/mt7621/base-files/etc/board.d/01_leds
## 复制小米路由配置文件到编译目录
# MT7628
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7628an_xiaomi_mi-router-4c.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-4c.dts
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7628an_xiaomi_mi-router-3c.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-3c.dts
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7628an_xiaomi_mi-router-3a.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7628an_xiaomi_mi-router-3a.dts
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt76x8/mt76x8.mk $GITHUB_WORKSPACE/openwrt/target/linux/ramips/image/mt76x8.mk
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt76x8/02_network $GITHUB_WORKSPACE/openwrt/target/linux/ramips/mt76x8/base-files/etc/board.d/02_network
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt76x8/mac80211.sh $GITHUB_WORKSPACE/openwrt/package/kernel/mac80211/files/lib/wifi/mac80211.sh
# MT7620
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620a_xiaomi_mi-router-3x.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7620a_xiaomi_mi-router-3x.dts
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/mt7620.mk $GITHUB_WORKSPACE/openwrt/target/linux/ramips/image/mt7620.mk
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/02_network $GITHUB_WORKSPACE/openwrt/target/linux/ramips/mt7620/base-files/etc/board.d/02_network
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/mac80211.sh $GITHUB_WORKSPACE/openwrt/package/kernel/mac80211/files/lib/wifi/mac80211.sh
# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# 修改软件包版本为大杂烩-openwrt21.02
sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-21.02/github.com\/Lienol\/openwrt-packages.git;21.02/g' feeds.conf.default
sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-21.02/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 修改软件包版本为大杂烩-openwrt22.03
# sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-22.03/github.com\/coolsnowwolf\/packages.git;master/g' feeds.conf.default
# sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-22.03/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 增加软件包
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;master' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small.git;master' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package.git;main' feeds.conf.default
# sed -i '$a src-git kiddin9 https://github.com/kiddin9/openwrt-packages.git;master' feeds.conf.default


# 预下载主题
#git clone https://github.com/jerrykuku/luci-theme-argon package/yuos/luci-theme-argon

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full luci/g' include/target.mk

# 修改默认编译LUCI进系统
sed -i 's/ppp-mod-pppoe/ppp-mod-pppoe default-settings luci curl/g' include/target.mk

# 修改默认红米AC2100 wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认E8820V2 wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt76x2 kmod-usb3 kmod-usb-ledtrig-usbport luci/kmod-mt7603e kmod-mt7612e luci-app-mtwifi kmod-usb3 kmod-usb-ledtrig-usbport wpad luci/g' target/linux/ramips/image/mt7621.mk

# 修改默认小米路由3G wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt76x2/kmod-mt7603e kmod-mt76x2e luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认斐讯K2Pwifi驱动为闭源驱动
sed -i 's/kmod-mt7615e kmod-mt7615-firmware/-luci-newapi -wpad-openssl kmod-mt7615d_dbdc wireless-tools/g' target/linux/ramips/image/mt7621.mk

# 设置闭源驱动开机自启
sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local
# 单独拉取软件包
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings
git clone -b main --single-branch https://github.com/yuos-bit/other package/yuos


# 添加5.4内核ACC、shortcut-fe补丁
# netfilter补丁
cp -R $GITHUB_WORKSPACE/patchs/613-netfilter_optional_tcp_window_check.patch $GITHUB_WORKSPACE/openwrt/target/linux/generic/pending-5.4/613-netfilter_optional_tcp_window_check.patch
rm -f ./target/linux/generic/hack-5.4/250-netfilter_depends.patch
rm -f ./target/linux/generic/hack-5.4/650-netfilter-add-xt_OFFLOAD-target.patch
rm -f ./target/linux/generic/hack-5.4/601-netfilter-export-udp_get_timeouts-function.patch
rm -f ./target/linux/generic/hack-5.4/645-netfilter-connmark-introduce-set-dscpmark.patch
rm -f ./target/linux/generic/hack-5.4/647-netfilter-flow-acct.patch

wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/250-netfilter_depends.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/650-netfilter-add-xt_OFFLOAD-target.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/601-netfilter-export-udp_get_timeouts-function.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/645-netfilter-connmark-introduce-set-dscpmark.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/647-netfilter-flow-acct.patch
# netfilter补丁
rm -f ./target/linux/generic/hack-5.4/661-use_fq_codel_by_default.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/661-use_fq_codel_by_default.patch
rm -f ./target/linux/generic/hack-5.4/662-remove_pfifo_fast.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/662-remove_pfifo_fast.patch
rm -f ./target/linux/generic/hack-5.4/721-phy_packets.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/721-phy_packets.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/yuos-bit/Openwrt-sfe-flowoffload-linux-5.4/master/952-net-conntrack-events-support-multiple-registrant.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/992-add-ndo-do-ioctl.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/999-thermal-tristate.patch

# 修改feeds里的luci-app-firewall加速开关等源码包
wget -P ./feeds/luci/applications/luci-app-firewall/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/applications/luci-app-firewall/patches/001-luci-app-firewall-Enable-FullCone-NAT.patch
pushd feeds/luci/applications/luci-app-firewall
patch -p1 < 001-luci-app-firewall-Enable-FullCone-NAT.patch
popd
# 全锥形NAT修复
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch
# Patch LuCI
pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd

##补充包##

## 锐捷校园网
git clone -b master https://github.com/Zxilly/UA2F package/yuos/UA2F
## 修复 C_STANDARD is set to invalid value '17' 报错
## 参阅：https://cmake.org/cmake/help/v3.27/prop_tgt/CXX_STANDARD.html
# sed -i 's/VERSION 3.16/VERSION 3.27.6/g' package/yuos/UA2F/CMakeLists.txt
# 确定cmake最低版本
# sed -i 's/set(CMAKE_C_STANDARD 17)/set_property(TARGET tgt PROPERTY C_STANDARD 11)/g' package/yuos/UA2F/CMakeLists.txt
# sed -i '4a set(CMAKE_C_STANDARD_REQUIRED ON)' package/yuos/UA2F/CMakeLists.txt
# sed -i '5a set_property(TARGET tgt PROPERTY C_STANDARD 11)' package/yuos/UA2F/CMakeLists.txt

# 单独拉取软件包
# 防检测
git clone -b master https://github.com/CHN-beta/rkp-ipid package/yuos/rkp-ipid
# 针对基于 IPv4 数据包包头内的 Identification 字段的检测的解决方案

git clone -b main https://github.com/lucikap/Brukamen package/yuos/Brukamen
# 防检测
git clone -b main https://github.com/a76yyyy/HustWebAuth package/yuos/HustWebAuth
# 网页认证

# git clone -b master https://github.com/CHN-beta/xmurp-ua package/yuos/xmurp-ua
# 使用 XMURP-UA 修改 UA

# 设置开机自启加入防火墙 针对基于 IPv4 数据包包头内的 TTL 字段的检测的解决方案
sed -i '3a iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' package/base-files/files/etc/rc.local
sed -i '4a iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' package/base-files/files/etc/rc.local
sed -i '6a # 防 IPID 检测' package/base-files/files/etc/rc.local
sed -i '7a iptables -t mangle -N IPID_MOD' package/base-files/files/etc/rc.local
sed -i '8a iptables -t mangle -A FORWARD -j IPID_MOD' package/base-files/files/etc/rc.local
sed -i '9a iptables -t mangle -A OUTPUT -j IPID_MOD' package/base-files/files/etc/rc.local
sed -i '10a iptables -t mangle -A IPID_MOD -d 0.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '11a iptables -t mangle -A IPID_MOD -d 127.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '12a # 由于本校局域网是 A 类网，所以我将这一条注释掉了，具体要不要注释结合你所在的校园网内网类型' package/base-files/files/etc/rc.local
sed -i '13a # iptables -t mangle -A IPID_MOD -d 10.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '14a iptables -t mangle -A IPID_MOD -d 172.16.0.0/12 -j RETURN' package/base-files/files/etc/rc.local
sed -i '15a iptables -t mangle -A IPID_MOD -d 192.168.0.0/16 -j RETURN' package/base-files/files/etc/rc.local
sed -i '16a iptables -t mangle -A IPID_MOD -d 255.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '17a iptables -t mangle -A IPID_MOD -j MARK --set-xmark 0x10/0x10' package/base-files/files/etc/rc.local
sed -i '18a # 防时钟偏移检测' package/base-files/files/etc/rc.local
sed -i '19a iptables -t nat -N ntp_force_local' package/base-files/files/etc/rc.local
sed -i '20a iptables -t nat -I PREROUTING -p udp --dport 123 -j ntp_force_local' package/base-files/files/etc/rc.local
sed -i '21a iptables -t nat -A ntp_force_local -d 0.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '22a iptables -t nat -A ntp_force_local -d 127.0.0.0/8 -j RETURN' package/base-files/files/etc/rc.local
sed -i '23a iptables -t nat -A ntp_force_local -d 192.168.0.0/16 -j RETURN' package/base-files/files/etc/rc.local
sed -i '24a iptables -t nat -A ntp_force_local -s 192.168.0.0/16 -j DNAT --to-destination 192.168.1.1' package/base-files/files/etc/rc.local
sed -i '25a # 通过 iptables 修改 TTL 值' package/base-files/files/etc/rc.local
sed -i '26a iptables -t mangle -A POSTROUTING -j TTL --ttl-set 64' package/base-files/files/etc/rc.local
# 自定义主题
rm -rf feeds/luci/themes/luci-theme-netgear

##补充包##
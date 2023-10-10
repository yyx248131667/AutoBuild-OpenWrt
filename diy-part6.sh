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
#
## 复制小米路由配置文件到编译目录
# MT7620
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620a_xiaomi_mi-router-3x.dts $GITHUB_WORKSPACE/openwrt/target/linux/ramips/dts/mt7620a_xiaomi_mi-router-3x.dts
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/mt7620.mk $GITHUB_WORKSPACE/openwrt/target/linux/ramips/image/mt7620.mk
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/02_network $GITHUB_WORKSPACE/openwrt/target/linux/ramips/mt7620/base-files/etc/board.d/02_network
cp -R $GITHUB_WORKSPACE/patchs/xiaomi_mi-router/mt7620/mac80211.sh $GITHUB_WORKSPACE/openwrt/package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改软件包版本为大杂烩-openwrt22.03
sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-22.03/github.com\/coolsnowwolf\/packages.git;master/g' feeds.conf.default
sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-22.03/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 增加软件包
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;master' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small.git;master' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package.git;main' feeds.conf.default


# 修改默认第一排插件
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# # 修改默认第二排插件
sed -i 's/firewall4/firewall block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun/g' include/target.mk

# # 修改默认第三排插件
sed -i 's/nftables/nftables iptables-mod-tproxy/g' include/target.mk

# # 修改默认第四排插件
sed -i 's/kmod-nft-offload/kmod-nft-offload curl ca-certificates/g' include/target.mk

# # 修改默认第五排插件
sed -i 's/odhcp6c/odhcp6c iptables-mod-tproxy iptables-mod-extra/g' include/target.mk

# # 修改默认第六排插件
sed -i 's/odhcpd-ipv6only/odhcpd-ipv6only ipset ip-full default-settings luci/g' include/target.mk

# 修改默认红米AC2100 wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/yuos

# 单独拉取 lean包到package 目录
git clone -b main https://github.com/yuos-bit/other package/lean

# 设置闭源驱动开机自启
# sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local

##补充包##

## 锐捷校园网
git clone -b master https://github.com/Zxilly/UA2F package/yuos/UA2F
# 防检测
git clone -b master https://github.com/CHN-beta/rkp-ipid package/yuos/rkp-ipid
# 防检测
git clone -b main https://github.com/lucikap/Brukamen package/yuos/Brukamen
# 防检测
git clone -b main https://github.com/a76yyyy/HustWebAuth package/yuos/HustWebAuth
# 网页认证


# golang更新到1.15.3
# sed -i 's/GO_VERSION_PATCH:=2/GO_VERSION_PATCH:=3/g' feeds/packages/lang/golang/golang/Makefile
# sed -i 's/28bf9d0bcde251011caae230a4a05d917b172ea203f2a62f2c2f9533589d4b4d/896a602570e54c8cdfc2c1348abd4ffd1016758d0bd086ccd9787dbfc9b64888/g' feeds/packages/lang/golang/golang/Makefile
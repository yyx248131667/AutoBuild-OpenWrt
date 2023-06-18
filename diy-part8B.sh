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

# 预下载主题
#git clone https://github.com/jerrykuku/luci-theme-argon package/yuos/luci-theme-argon

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full luci/g' include/target.mk

# 修改默认编译LUCI进系统
sed -i 's/ppp-mod-pppoe/ppp-mod-pppoe default-settings luci curl/g' include/target.mk

# 修改默认红米AC2100 wifi驱动为闭源驱动
sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认小米路由3G wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt76x2/kmod-mt7603e kmod-mt76x2e luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认斐讯K2Pwifi驱动为闭源驱动
# sed -i 's/kmod-mt7615e kmod-mt7615-firmware/-luci-newapi -wpad-openssl kmod-mt7615d_dbdc wireless-tools/g' target/linux/ramips/image/mt7621.mk

# 设置闭源驱动开机自启
sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings
git clone -b main --single-branch https://github.com/yuos-bit/other package/yuos

#FullCone Patch
git clone -b master --single-branch https://github.com/lxz1104/openwrt-fullconenat package/fullconenat


#patches
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/0001-tools-add-upx-ucl-support.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/1001-dnsmasq_add_filter_aaaa_option.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/1002-fw3_fullconenat.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/1003-luci-app-firewall_add_fullcone.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/2001-add-5.14-support.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/2003-mod-for-k514.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/910-mini-ttl.patch
wget https://github.com/quintus-lab/openwrt-rockchip/raw/master/patches/911-dnsmasq-filter-aaaa.patch
wget https://github.com/LGA1150/openwrt-fullconenat/raw/master/patches/000-printk.patch

patch -p1 < ./0001-tools-add-upx-ucl-support.patch
patch -p1 < ./1001-dnsmasq_add_filter_aaaa_option.patch
patch -p1 < ./1002-fw3_fullconenat.patch
patch -p1 < ./1003-luci-app-firewall_add_fullcone.patch
patch -p1 < ./2001-add-5.14-support.patch
patch -p1 < ./2003-mod-for-k514.patch
patch -p1 < ./910-mini-ttl.patch
patch -p1 < ./911-dnsmasq-filter-aaaa.patch
patch -p1 < ./000-printk.patch

#shortcut-fe patches
wget https://github.com/MeIsReallyBa/Openwrt-sfe-flowoffload-linux-5.4/raw/master/952-net-conntrack-events-support-multiple-registrant.patch
wget https://github.com/MeIsReallyBa/Openwrt-sfe-flowoffload-linux-5.4/raw/master/999-shortcut-fe-support.patch

patch -p1 < ./952-net-conntrack-events-support-multiple-registrant.patch
patch -p1 < ./999-shortcut-fe-support.patch


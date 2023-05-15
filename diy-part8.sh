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
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/molun/luci-theme-infinityfreedom

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full luci/g' include/target.mk

# 单独拉取 lean包到package 目录
# git clone -b main https://github.com/yuos-bit/other package/lean

# 修改默认红米AC2100 wifi驱动为闭源驱动
# sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认小米路由3G wifi驱动为闭源驱动
sed -i 's/kmod-mt7603 kmod-mt76x2/kmod-mt7603e kmod-mt76x2e luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 修改默认斐讯K2Pwifi驱动为闭源驱动
sed -i 's/kmod-mt7615e kmod-mt7615-firmware/-luci-newapi -wpad-openssl kmod-mt7615d_dbdc wireless-tools/g' target/linux/ramips/image/mt7621.mk

# 设置闭源驱动开机自启
# sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings
# git clone -b lede-default-settings https://github.com/yuos-bit/other package/default-settings

# SFE补丁
# wget -O target/linux/ramips/patches-5.4/952-net-conntrack-events-support-multiple-registrant.patch https://github.com/yuos-bit/other/releases/download/openwrt-patch/952-net-conntrack-events-support-multiple-registrant.patch
# wget -O target/linux/ramips/patches-5.4/999-shortcut-fe-support.patch https://github.com/yuos-bit/other/releases/download/openwrt-patch/999-shortcut-fe-support.patch 

#patches
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/dnsmasq-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/luci-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/luci-app-firewall_add_sfe_switch.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/use_json_object_new_int64.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/kernel_crypto-add-rk3328-crypto-support.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/900-add-filter-aaaa-option.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/998-rockchip-enable-i2c0-on-NanoPi-R2S.patch
wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/991-r8152-Add-module-param-for-customized-LEDs.patch

patch -p1 < ./kernel_crypto-add-rk3328-crypto-support.patch
patch -p1 < ./use_json_object_new_int64.patch
patch -p1 < ./dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ./luci-add-filter-aaaa-option.patch
patch -p1 < ./luci-app-firewall_add_sfe_switch.patch
cp ./900-add-filter-aaaa-option.patch package/network/services/dnsmasq/patches/
cp ./998-rockchip-enable-i2c0-on-NanoPi-R2S.patch ./target/linux/rockchip/patches-5.4/
cp ./991-r8152-Add-module-param-for-customized-LEDs.patch ./target/linux/rockchip/patches-5.4/

svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/luci-app-cpufreq package/lean/luci-app-cpufreq
wget https://github.com/project-openwrt/R2S-OpenWrt/raw/master/PATCH/luci-app-freq.patch
patch -p1 < ./luci-app-freq.patch

#FullCone Patch
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# Patch FireWall for fullcone
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch

pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
#Patch Kernel for fullcone
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd

# SFE kernel patch
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/generic/hack-5.4/999-shortcut-fe-support.patch
popd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/new/shortcut-fe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/fast-classifier package/new/fast-classifier

wget https://github.com/quintus-lab/Openwrt-R2S/raw/master/patches/999-unlock-1608mhz-rk3328.patch
cp 999-unlock-1608mhz-rk3328.patch target/linux/rockchip/patches-5.4/


rm -rf ./feeds/packages/devel/gcc
svn co https://github.com/openwrt/packages/trunk/devel/gcc feeds/packages/devel/gcc


#AutoCore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore package/lean/autocore
#coremark
rm -rf ./feeds/packages/utils/coremark
rm -rf ./package/feeds/packages/coremark
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/coremark package/lean/coremark
sed -i 's,-DMULTIT,-Ofast -DMULTIT,g' package/lean/coremark/Makefile

git clone -b master --single-branch https://github.com/garypang13/luci-theme-edge package/new/luci-theme-edge

#修正架构
sed -i "s,boardinfo.system,'ARMv8',g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
chmod -R 755 ./
echo -e '\nQuintus Build @ '$(date "+%Y.%m.%d")'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION='$(date "+%Y.%m.%d")'" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Quintus Build@$(date "+%Y.%m.%d")" >> package/base-files/files/etc/openwrt_release

#install upx
mkdir -p staging_dir/host/bin/
ln -s /usr/bin/upx-ucl staging_dir/host/bin/upx
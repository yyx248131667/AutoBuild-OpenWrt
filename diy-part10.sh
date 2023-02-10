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
# sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-21.02/github.com\/Lienol\/openwrt-packages.git;21.02/g' feeds.conf.default
# sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-21.02/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 修改软件包版本为大杂烩-openwrt22.03
sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-22.03/github.com\/coolsnowwolf\/packages.git;master/g' feeds.conf.default
sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-22.03/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 增加软件包
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;master' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small.git;master' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package.git;main' feeds.conf.default

# 预下载主题
#git clone https://github.com/jerrykuku/luci-theme-argon package/yuos/luci-theme-argon
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/molun/luci-theme-infinityfreedom

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# 修改默认firewall4为firewall
sed -i 's/firewall4/firewall/g' include/target.mk

# 修改默认wifi驱动为闭源驱动
sed -i 's/kmod-mt7603 kmod-mt7615e kmod-mt7615-firmware/kmod-mt7603e kmod-mt7615d luci-app-mtwifi -wpad-openssl/g' target/linux/ramips/image/mt7621.mk

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings
# git clone -b lede-default-settings https://github.com/yuos-bit/other package/default-settings

# 单独拉取 lean包到package 目录
git clone -b main https://github.com/yuos-bit/other package/lean

# 删除多余的软件包
rm -rf package/lean/default-settings/

# 设置闭源驱动开机自启
wget -O package/base-files/files/wifi.up.sh https://github.com/yuos-bit/other/releases/download/shell/wifi.up.sh
# 自启权限
chmod +x package/base-files/files/wifi.up.sh
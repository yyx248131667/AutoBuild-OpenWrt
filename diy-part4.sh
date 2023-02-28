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
# sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-22.03/github.com\/Lienol\/openwrt-packages.git;21.02/g' feeds.conf.default
# sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-22.03/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 修改软件包版本为大杂烩-openwrt22.03
# sed -i 's/git.openwrt.org\/feed\/packages.git;openwrt-22.03/github.com\/coolsnowwolf\/packages.git;master/g' feeds.conf.default
# sed -i 's/git.openwrt.org\/project\/luci.git;openwrt-22.03/github.com\/coolsnowwolf\/luci.git;master/g' feeds.conf.default
# 增加软件包
# sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;master' feeds.conf.default
# sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
# sed -i '$a src-git small https://github.com/kenzok8/small.git;master' feeds.conf.default
# sed -i '$a src-git small8 https://github.com/kenzok8/small-package.git;main' feeds.conf.default

# 预下载主题
#git clone https://github.com/jerrykuku/luci-theme-argon package/yuos/luci-theme-argon
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/molun/luci-theme-infinityfreedom

# 修改默认dnsmasq为dnsmasq-full
# sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/yuos
# git clone -b lede-default-settings https://github.com/yuos-bit/other package/default-settings
# 单独拉取 lean包到package 目录
rm -rf package/lean
git clone -b main https://github.com/yuos-bit/other package/lean

# 修改xray版本为1.5.5
# sed -i 's/1.7.5/1.5.5/g' feeds/packages/net/xray-core/Makefile
# sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/3f8d04fef82a922c83bab43cac6c86a76386cf195eb510ccf1cc175982693893/g' feeds/packages/net/xray-core/Makefile
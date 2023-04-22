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

# 预下载主题
#git clone https://github.com/jerrykuku/luci-theme-argon package/yuos/luci-theme-argon
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/molun/luci-theme-infinityfreedom

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# 单独拉取 default-settings
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/yuos

# 单独拉取 lean包到package 目录
git clone -b main https://github.com/yuos-bit/other package/lean
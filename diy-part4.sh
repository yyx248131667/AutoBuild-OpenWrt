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

# 单独拉取软件包
# git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings
git clone -b main --single-branch https://github.com/yuos-bit/other package/yuos
git clone -b master https://github.com/yuos-bit/luci-theme-netgear.git package/yuos/luci-theme-netgear

# 补充包
git clone https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata
# 实时监控
git clone https://github.com/sirpdboy/luci-app-wizard package/luci-app-wizard
# 设置向导

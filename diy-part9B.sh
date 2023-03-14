#!/bin/bash
#=================================================
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#=================================================

# 修改默认IP
sed -i 's/192.168.1.1/10.32.0.1/g' package/base-files/files/bin/config_generate
# 修改网关
sed -i 's/192.168.$((addr_offset++)).1/10.32.$((addr_offset++)).1/g' package/base-files/files/bin/config_generate

# 修改主机名称
sed -i 's/OpenWrt/Yuos/g' package/base-files/files/bin/config_generate

# 修改默认wifi名称ssid为Xiaoyu-Wifi
# sed -i 's/ssid=OpenWrt/ssid=Xiaoyu-Wifi/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为1234567890
# sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#使用sed 在第四行后添加新字
# sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="MOLUN"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"MOLUN"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config

# 删除默认闭源wifi驱动
rm -rf package/lean/mt

# 拉取红米AC2100专属闭源wifi驱动
git clone -b master https://github.com/MeIsReallyBa/Redmi2100-WIFI-ProprietaryDriver-linux5.4 package/lean/mt/mt7603
# 拉取sfe-flowoffload-linux-5.4
git clone -b master https://github.com/MeIsReallyBa/Openwrt-sfe-flowoffload-linux-5.4 package/yuos/shortcut-fe
cp -R package/yuos/shortcut-fe/shortcut-fe package/kernel/shortcut-fe
cp package/yuos/shortcut-fe/952-net-conntrack-events-support-multiple-registrant.patch target/linux/generic/hack-5.4/
cp package/yuos/shortcut-fe/999-shortcut-fe-support.patch target/linux/generic/hack-5.4/
rm -rf package/lean/shortcut-fe
rm -rf package/yuos/shortcut-fe
# 拉取natflow
git clone -b master https://github.com/MeIsReallyBa/natflow package/yuos/natflow
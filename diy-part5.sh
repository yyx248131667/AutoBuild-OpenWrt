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

# 修改版本号
# sed -i "s/OpenWrt/小渔学长 build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/default-settings/files/zzz-default-settings

# 修改默认wifi名称ssid为Xiaomi-Wifi
sed -i 's/ssid=OpenWrt/ssid=Xiaoyu-Wifi/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# 修改登陆密码
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/default-settings/files/zzz-default-settings
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings

# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="MOLUN"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"MOLUN"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config

# 修改 edge 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
#sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' openwrt/feeds/luci/collections/luci/Makefile

#Enable 802.11k/v/r
#sed -i 's/RRMEnable=0/RRMEnable=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#sed -i 's/RRMEnable=0/RRMEnable=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat
#sed -i 's/FtSupport=0/FtSupport=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#sed -i 's/FtSupport=0/FtSupport=1/g' package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat
#echo 'WNMEnable=1' >> package/kernel/mt-drivers/mt_wifi/files/mt7615.1.2G.dat
#echo 'WNMEnable=1' >> package/kernel/mt-drivers/mt_wifi/files/mt7615.1.5G.dat

# 修改插件名字（修改名字后不知道会不会对插件功能有影响，自己多测试）
#sed -i 's/"BaiduPCS Web"/"百度网盘"/g' package/lean/luci-app-baidupcs-web/luasrc/controller/baidupcs-web.lua
#sed -i 's/cbi("qbittorrent"),_("qBittorrent")/cbi("qbittorrent"),_("BT下载")/g' package/lean/luci-app-qbittorrent/luasrc/controller/qbittorrent.lua
#sed -i 's/"aMule设置"/"电驴下载"/g' package/lean/luci-app-amule/po/zh-cn/amule.po
#sed -i 's/"网络存储"/"存储"/g' package/lean/luci-app-amule/po/zh-cn/amule.po
#sed -i 's/"网络存储"/"存储"/g' package/lean/luci-app-vsftpd/po/zh-cn/vsftpd.po
#sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' package/lean/luci-app-flowoffload/po/zh-cn/flowoffload.po
#sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' package/lean/luci-app-sfe/po/zh-cn/sfe.po
#sed -i 's/"实时流量监测"/"流量"/g' package/lean/luci-app-wrtbwmon/po/zh-cn/wrtbwmon.po
#sed -i 's/"KMS 服务器"/"KMS激活"/g' package/lean/luci-app-vlmcsd/po/zh-cn/vlmcsd.zh-cn.po
#sed -i 's/"USB 打印服务器"/"打印服务"/g' package/lean/luci-app-usb-printer/po/zh-cn/usb-printer.po
#sed -i 's/"网络存储"/"存储"/g' package/lean/luci-app-usb-printer/po/zh-cn/usb-printer.po
#sed -i 's/TTYD 终端/命令窗/g' feeds/luci/transplant/luci-app-ttyd/po/zh-cn/terminal.po
#sed -i 's/"Web 管理"/"Web管理"/g' package/lean/luci-app-webadmin/po/zh-cn/webadmin.po
#sed -i 's/"管理权"/"改密码"/g' feeds/luci/modules/luci-base/po/zh-cn/base.po
#sed -i 's/"带宽监控"/"监视"/g' feeds/luci/applications/luci-app-nlbwmon/po/zh-cn/nlbwmon.po

# 修改v2ray版本为4.27.5
# sed -i 's/5.4.0/4.27.5/g' feeds/small/v2ray-core/Makefile
# sed -i 's/86be35461a9dc7d037e0045771d99f1eae284fdb7aa0818a6782d18b6b003fca/f289d8d85ab0851851a6e3c101226e77bed0052fd60f9185df8852b601e657f8/g' feeds/small/v2ray-core/Makefile

# sed -i 's/5.4.0/4.27.5/g' feeds/small8/v2ray-core/Makefile
# sed -i 's/86be35461a9dc7d037e0045771d99f1eae284fdb7aa0818a6782d18b6b003fca/f289d8d85ab0851851a6e3c101226e77bed0052fd60f9185df8852b601e657f8/g' feeds/small8/v2ray-core/Makefile

# 修改xray版本为1.4.2
sed -i 's/1.7.5/1.4.2/g' feeds/packages/net/xray-core/Makefile
sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc/g' feeds/packages/net/xray-core/Makefile

sed -i 's/1.7.5/1.4.2/g' feeds/helloworld/xray-core/Makefile
sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc/g' feeds/helloworld/xray-core/Makefile

sed -i 's/1.7.5/1.4.2/g' package/feeds/packages/xray-core/Makefile
sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc/g' package/feeds/packages/xray-core/Makefile

sed -i 's/1.7.5/1.4.2/g' feeds/small/xray-core/Makefile
sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc/g' feeds/small/xray-core/Makefile

sed -i 's/1.7.5/1.4.2/g' feeds/small8/xray-core/Makefile
sed -i 's/a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3/565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc/g' feeds/small8/xray-core/Makefile
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
sed -i 's/ssid=OpenWrt/ssid=Xiaomi-Wifi/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为1234567890
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#使用sed 在第四行后添加新字
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="MOLUN"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"MOLUN"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config

# 添加5.4内核ACC、shortcut-fe补丁
# openwrt21.02 netfilter补丁\
cp -rf $GITHUB_WORKSPACE/patchs/firewall/* package/firmware/
patch -p1 < package/firmware/001-fix-firewall-flock.patch

# nft-fullcone
git clone -b main --single-branch https://github.com/fullcone-nat-nftables/nftables-1.0.5-with-fullcone package/nftables
git clone -b master --single-branch https://github.com/fullcone-nat-nftables/libnftnl-1.2.4-with-fullcone package/libnftnl

# 打补丁
wget -O package/firmware/xt_FULLCONENAT.c https://raw.githubusercontent.com/Chion82/netfilter-full-cone-nat/master/xt_FULLCONENAT.c
cp -rf package/firmware/xt_FULLCONENAT.c package/nftables/include/linux/netfilter/xt_FULLCONENAT.c
cp -rf package/firmware/xt_FULLCONENAT.c package/libnftnl/include/linux/netfilter/xt_FULLCONENAT.c
cp -rf package/firmware/xt_FULLCONENAT.c package/libs/libnetfilter-conntrack/xt_FULLCONENAT.c

# dnsmasq-full升级2.89
rm -rf package/network/services/dnsmasq
cp -rf $GITHUB_WORKSPACE/patchs/5.4/dnsmasq package/network/services/dnsmasq

# 测试编译时间
YUOS_DATE="$(date +%Y.%m.%d)(纯享版)"
BUILD_STRING=${BUILD_STRING:-$YUOS_DATE}
echo "Write build date in openwrt : $BUILD_DATE"
echo -e '\n小渔学长 Build @ '${BUILD_STRING}'\n'  >> package/base-files/files/etc/banner
sed -i '/DISTRIB_REVISION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_REVISION=''" >> package/base-files/files/etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='小渔学长 Build @ ${BUILD_STRING}'" >> package/base-files/files/etc/openwrt_release
sed -i '/luciversion/d' feeds/luci/modules/luci-base/luasrc/version.lua

# 临时处理
rm -rf target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
rm -rf target/linux/generic/hack-5.4/953-net-patch-linux-kernel-to-support-shortcut-fe.patch

#升级golang
find . -type d -name "golang" -exec rm -r {} +
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
# mkdir -p feeds/packages/lang/golang/golang/
# cp -rf $GITHUB_WORKSPACE/patchs/5.4/golang/* feeds/packages/lang/golang/golang/

#设置软件唯一性
find . -type d -name "gn" -exec rm -r {} +
mkdir -p feeds/small8/gn/
cp -rf $GITHUB_WORKSPACE/patchs/5.4/gn/* feeds/small8/gn/
find . -type d -name "naiveproxy" -exec rm -r {} +
mkdir -p feeds/small8/naiveproxy/
cp -rf $GITHUB_WORKSPACE/patchs/5.4/naiveproxy/* feeds/small8/naiveproxy/
rm -rf feeds/helloworld/hysteria
rm -rf feeds/small/hysteria
cp -rf $GITHUB_WORKSPACE/patchs/5.4/hysteria/* feeds/packages/net/hysteria/
rm -rf feeds/small/luci-app-passwall2
rm -rf feeds/small/brook
rm -rf feeds/helloworld/shadowsocks-rust
rm -rf feeds/small/shadowsocks-rust
rm -rf feeds/helloworld/simple-obfs
rm -rf feeds/small/simple-obfs
rm -rf feeds/helloworld/v2ray-plugin
rm -rf feeds/small/v2ray-plugin
rm -rf feeds/helloworld/xray-core
rm -rf feeds/small/xray-core

cp -rf $GITHUB_WORKSPACE/patchs/5.4/tailscale/* feeds/packages/net/tailscale/

# 添加iptables-mod-socket
cp -rf $GITHUB_WORKSPACE/patchs/5.4/iptables-mod-socket.patch $GITHUB_WORKSPACE/openwrt/package/iptables-mod-socket.patch
patch -p1 < $GITHUB_WORKSPACE/openwrt/package/iptables-mod-socket.patch

# 添加 kmod-nf-tproxy 依赖
sed -i 's/DEPENDS\+=+kmod-ipt-conntrack +IPV6:kmod-nf-conntrack6/DEPENDS\+=+kmod-nf-tproxy +kmod-nf-conntrack +IPV6:kmod-nf-conntrack6/' package/kernel/linux/modules/netfilter.mk

# 添加 ipt-socket 依赖
sed -i '/$(eval $(call KernelPackage,ipt-led))/a \
\
define KernelPackage/ipt-socket\n\
  TITLE:=Iptables socket matching support\n\
  DEPENDS+=+kmod-nf-socket +kmod-nf-conntrack +IPV6:kmod-nf-conntrack6\n\
  KCONFIG:=$(KCONFIG_IPT_SOCKET)\n\
  FILES:=$(foreach mod,$(IPT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_SOCKET-m)))\n\
  $(call AddDepends/ipt)\n\
endef\n\
\n\
define KernelPackage/ipt-socket/description\n\
  Kernel modules for socket matching\n\
endef\n\
\n\
$(eval $(call KernelPackage,ipt-socket))' package/kernel/linux/modules/netfilter.mk

# 添加 iptables-mod-socket 依赖
sed -i '382i\ \
define Package/iptables-mod-socket\n\
$(call Package/iptables/Module, +kmod-ipt-socket)\n\
  TITLE:=Socket match iptables extensions\n\
endef\n\
\n\
define Package/iptables-mod-socket/description\n\
Socket match iptables extensions.\n\
\n\
 Matches:\n\
  - socket\n\
\n\
endef' package/network/utils/iptables/Makefile

# 添加 kmod-inet-diag 依赖
sed -i '/define KernelPackage\/wireguard/,/$(eval $(call KernelPackage,wireguard))/c\
\
define KernelPackage/inet-diag\n\
  SUBMENU:=$(NETWORK_SUPPORT_MENU)\n\
  TITLE:=INET diag support for ss utility\n\
  KCONFIG:= \\\n\
	CONFIG_INET_DIAG \\\n\
	CONFIG_INET_TCP_DIAG \\\n\
	CONFIG_INET_UDP_DIAG \\\n\
	CONFIG_INET_RAW_DIAG \\\n\
	CONFIG_INET_DIAG_DESTROY=n\n\
  FILES:= \\\n\
	$(LINUX_DIR)/net/ipv4/inet_diag.ko \\\n\
	$(LINUX_DIR)/net/ipv4/tcp_diag.ko \\\n\
	$(LINUX_DIR)/net/ipv4/udp_diag.ko \\\n\
	$(LINUX_DIR)/net/ipv4/raw_diag.ko@ge4.10\n\
  AUTOLOAD:=$(call AutoLoad,31,inet_diag tcp_diag udp_diag raw_diag@ge4.10)\n\
endef\n\
\n\
define KernelPackage/inet-diag/description\n\
  Support for INET (TCP, DCCP, etc) socket monitoring interface used by\n\
  native Linux tools such as ss.\n\
endef\n\
\n\
$(eval $(call KernelPackage,inet-diag))' package/kernel/linux/modules/netsupport.mk

# 添加 kmod-nf-socket 依赖
sed -i '/$(eval \$(call KernelPackage,nft-queue))/a\
\
define KernelPackage/nft-socket\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables socket support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-socket\n\
  FILES:=$(foreach mod,$(NFT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_SOCKET-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_SOCKET)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-socket))\n\
\n\
define KernelPackage/nft-tproxy\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables tproxy support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-tproxy +kmod-nf-conntrack\n\
  FILES:=$(foreach mod,$(NFT_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_TPROXY-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_TPROXY)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-tproxy))\n\
\n\
define KernelPackage/nft-compat\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables compat support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-ipt\n\
  FILES:=$(foreach mod,$(NFT_COMPAT-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_COMPAT-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_COMPAT)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-compat))\n\
\n\
define KernelPackage/nft-xfrm\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables xfrm support (ipsec)\n\
  DEPENDS:=+kmod-nft-core\n\
  FILES:=$(foreach mod,$(NFT_XFRM-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_XFRM-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_XFRM)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-xfrm))' package/kernel/linux/modules/netfilter.mk


### 后补的

#FullCone Patch
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# Patch FireWall for fullcone
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://raw.githubusercontent.com/LGA1150/fullconenat-fw3-patch/master/fullconenat.patch

pushd feeds/luci
wget -O- https://raw.githubusercontent.com/LGA1150/fullconenat-fw3-patch/master/luci.patch | git apply
popd

### 后补的
# SFE kernel patch
cp -n $GITHUB_WORKSPACE/patchs/5.4/hack-5.4/* target/linux/generic/hack-5.4/
cp -n $GITHUB_WORKSPACE/patchs/5.4/pending-5.4/* target/linux/generic/pending-5.4/
cp -rf $GITHUB_WORKSPACE/patchs/5.4/sfe/* package/yuos/


# 解决kconfig补丁
wget -P target/linux/generic/backport-5.4/ https://raw.githubusercontent.com/hanwckf/immortalwrt-mt798x/openwrt-21.02/target/linux/generic/backport-5.4/500-v5.15-fs-ntfs3-Add-NTFS3-in-fs-Kconfig-and-fs-Makefile.patch
patch -p1 < target/linux/generic/backport-5.4/500-v5.15-fs-ntfs3-Add-NTFS3-in-fs-Kconfig-and-fs-Makefile.patch

mkdir -p target/linux/generic/files-5.4/
cp -rf $GITHUB_WORKSPACE/patchs/5.4/files-5.4/* target/linux/generic/files-5.4/

#添加 kmod-inet-diag
sed -i '1227i\
define KernelPackage/inet-diag\n\
  SUBMENU:=$(NETWORK_SUPPORT_MENU)\n\
  TITLE:=INET diag support for ss utility\n\
  KCONFIG:= \\\n\
\tCONFIG_INET_DIAG \\\n\
\tCONFIG_INET_TCP_DIAG \\\n\
\tCONFIG_INET_UDP_DIAG \\\n\
\tCONFIG_INET_RAW_DIAG \\\n\
\tCONFIG_INET_DIAG_DESTROY=n\n\
  FILES:= \\\n\
\t$(LINUX_DIR)/net/ipv4/inet_diag.ko \\\n\
\t$(LINUX_DIR)/net/ipv4/tcp_diag.ko \\\n\
\t$(LINUX_DIR)/net/ipv4/udp_diag.ko \\\n\
\t$(LINUX_DIR)/net/ipv4/raw_diag.ko\n\
  AUTOLOAD:=$(call AutoLoad,31,inet_diag tcp_diag udp_diag raw_diag)\n\
endef\n\
\n\
define KernelPackage/inet-diag/description\n\
Support for INET (TCP, DCCP, etc) socket monitoring interface used by\n\
native Linux tools such as ss.\n\
endef\n\
\n\
$(eval $(call KernelPackage,inet-diag))' package/kernel/linux/modules/netsupport.mk

# 测试
cp -rf $GITHUB_WORKSPACE/patchs/5.4/netsupport.mk package/kernel/linux/modules/netsupport.mk
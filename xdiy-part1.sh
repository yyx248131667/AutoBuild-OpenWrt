#!/bin/bash
#=================================================
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#=================================================


# 增加软件包
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git;main' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small.git;master' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package.git;main' feeds.conf.default

# 修改默认编译LUCI进系统
sed -i 's/ppp-mod-pppoe/iptables-mod-tproxy iptables-mod-extra ipset ip-full ppp-mod-pppoe curl ca-certificates/g' include/target.mk

# 设置闭源驱动开机自启
#sed -i '2a ifconfig rai0 up\nifconfig ra0 up\nbrctl addif br-lan rai0\nbrctl addif br-lan ra0' package/base-files/files/etc/rc.local

# 单独拉取软件包
git clone -b Lienol-default-settings https://github.com/yuos-bit/other package/default-settings


# # 删除冲突包
# rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}

# 修改默认dnsmasq为dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full firewall iptables block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-ipt-raw6 kmod-tun/g' include/target.mk

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


# nf-tproxy nf-socket
sed -i '/$(eval $(call KernelPackage,nf-flow))/a\
\
define KernelPackage/nf-socket\n  SUBMENU:=$(NF_MENU)\n  TITLE:=Netfilter socket lookup support\n  KCONFIG:= $(KCONFIG_NF_SOCKET)\n  FILES:=$(foreach mod,$(NF_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_SOCKET-m)))\nendef\n\n$(eval $(call KernelPackage,nf-socket))\
\
define KernelPackage/nf-tproxy\n  SUBMENU:=$(NF_MENU)\n  TITLE:=Netfilter tproxy support\n  KCONFIG:= $(KCONFIG_NF_TPROXY)\n  FILES:=$(foreach mod,$(NF_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)\n  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_TPROXY-m)))\nendef\n\n$(eval $(call KernelPackage,nf-tproxy))' package/kernel/linux/modules/netfilter.mk

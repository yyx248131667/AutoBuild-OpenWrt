#
# Copyright (C) 2011-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=1.7.5
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/XTLS/Xray-core/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3

define Package/xray-core
  TITLE:=A platform for building proxies to bypass network restrictions
  SECTION:=net
  CATEGORY:=Network
  URL:=https://xtls.github.io
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
endef


define Package/xray/description
  Xray, Penetrates Everything. It helps you to build your own computer network.
  It secures your network connections and thus protects your privacy.
endef

define Build/Compile
    # Nothing to compile, just install precompiled binaries
endef

define Package/xray-core/install
    $(INSTALL_DIR) $(1)/usr/bin/
    $(INSTALL_BIN) $(GITHUB_WORKSPACE)/xray $(1)/usr/bin/xray
endef

$(eval $(call BuildPackage,xray-core))
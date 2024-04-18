#
# Copyright (C) 2011-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=upx
PKG_VERSION:=4.2.3
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-mipsel_linux.tar.xz
PKG_SOURCE_URL:=https://github.com/upx/upx/releases/download/v$(PKG_VERSION)
PKG_MD5SUM:=dd67b425ec7aa5594913df9aaf360241

define Package/upx
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=UPX - the Ultimate Packer for eXecutables
	URL:=https://upx.github.io/
	DEPENDS:=+libc
endef

define Package/upx/description
	UPX is a free, portable, extendable, high-performance executable packer
	for several different executable formats.
endef

define Build/Compile
    # Nothing to compile, just install precompiled binaries
endef

define Package/upx/install
    $(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/upx-$(PKG_VERSION)-mipsel_linux/upx $(STAGING_DIR_HOST)/bin/upx
endef

$(eval $(call BuildPackage,upx))

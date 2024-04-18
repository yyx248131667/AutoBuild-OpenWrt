include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=1.7.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/XTLS/Xray-core/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3

PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE:=MPL-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/Xray-core-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=golang/host  upx/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/xtls/xray-core
GO_PKG_LDFLAGS:=-s -w
GO_PKG_BUILD_PKG:=$(GO_PKG)/main
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/core.build=OpenWrt \
	$(GO_PKG)/core.version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Download/upx
  FILE:=upx-4.2.3-amd64_linux.tar.xz
  URL_FILE:=upx.tar.xz
  URL:=https://github.com/upx/upx/releases/download/v4.2.3/
  HASH:=skip
endef

define Build/Prepare
  $(call Build/Prepare/Default)
  $(eval $(call Download,upx))
  $(TAR) --strip-components=1 -C $(PKG_BUILD_DIR)/ -xvf $(DL_DIR)/upx-4.2.3-amd64_linux.tar.xz
  $(CP) $(PKG_BUILD_DIR)/upx $(STAGING_DIR_HOST)/bin/upx
endef

define Package/xray-core
  TITLE:=A platform for building proxies to bypass network restrictions
  SECTION:=net
  CATEGORY:=Network
  URL:=https://xtls.github.io
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
endef

define Package/xray-core/description
  Xray, Penetrates Everything. It helps you to build your own computer network.
  It secures your network connections and thus protects your privacy.
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/main
endef

define Package/xray-core/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/
  $(STAGING_DIR_HOST)/bin/upx --lzma --best $(PKG_INSTALL_DIR)/usr/bin/main
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/main $(1)/usr/bin/xray
endef

$(eval $(call BuildPackage,xray-core))
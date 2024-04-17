include $(TOPDIR)/rules.mk

PKG_NAME := xray-core
PKG_VERSION := 1.7.5
PKG_RELEASE := 1

PKG_MAINTAINER := Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE := MPL-2.0
PKG_LICENSE_FILES := LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/xray-core
    TITLE := A platform for building proxies to bypass network restrictions
    SECTION := net
    CATEGORY := Network
    URL := https://xtls.github.io
    DEPENDS := +ca-bundle
endef

define Package/xray-core/description
    Xray, Penetrates Everything. It helps you to build your own computer network.
    It secures your network connections and thus protects your privacy.
endef

define Package/xray-core/install
    $(INSTALL_DIR) $(1)/usr/bin/
    $(INSTALL_BIN) $(THISDIR)/xray $(1)/usr/bin/xray
endef

$(eval $(call BuildPackage,xray-core))

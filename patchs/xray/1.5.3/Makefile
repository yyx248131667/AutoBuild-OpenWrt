include $(TOPDIR)/rules.mk

PKG_NAME := Xray-core
PKG_VERSION := 1.7.5
PKG_RELEASE := 77

PKG_SOURCE := $(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL := https://github.com/yuos-bit/other/archive/refs/tags/v$(PKG_VERSION).tar.gz
PKG_HASH := skip

PKG_INSTALL_DIR := /tmp/install_dir
TAR_FILE := $(PKG_NAME)-$(PKG_VERSION).tar.gz
TEMP_DIR := $(PKG_INSTALL_DIR)/temp
INSTALL_DIR := $(1)/usr/bin
BIN_NAME := xray

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

.PHONY: all clean

all: download extract install

download:
	@echo "Downloading $(PKG_SOURCE) from $(PKG_SOURCE_URL)..."
	mkdir -p $(DL_DIR)
	wget -O $(DL_DIR)/$(PKG_SOURCE) "$(PKG_SOURCE_URL)"

extract:
	@echo "Extracting $(PKG_SOURCE) to $(TEMP_DIR)..."
	mkdir -p $(TEMP_DIR)
	tar -xzvf $(DL_DIR)/$(PKG_SOURCE) -C $(TEMP_DIR) --strip-components=1

install:
	@echo "Installing $(BIN_NAME) to $(INSTALL_DIR)..."
	mkdir -p $(call INSTALL_DIR,$(1))
	cp $(TEMP_DIR)/$(BIN_NAME) $(call INSTALL_DIR,$(1))

clean:
	@echo "Cleaning up..."
	rm -rf $(PKG_INSTALL_DIR)

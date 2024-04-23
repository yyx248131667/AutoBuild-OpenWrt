PKG_INSTALL_DIR := /tmp/install_dir
DOWNLOAD_URL := https://github.com/yuos-bit/other/archive/refs/tags/v1.7.5.tar.gz
TAR_FILE := v1.7.5.tar.gz
TEMP_DIR := $(PKG_INSTALL_DIR)/temp
INSTALL_DIR := $(1)/usr/bin
BIN_NAME := xray

.PHONY: all clean

all: download extract install

download:
	@echo "Downloading $(TAR_FILE) from $(DOWNLOAD_URL)..."
	mkdir -p $(PKG_INSTALL_DIR)
	wget -O $(PKG_INSTALL_DIR)/$(TAR_FILE) $(DOWNLOAD_URL)

extract:
	@echo "Extracting $(TAR_FILE) to $(TEMP_DIR)..."
	mkdir -p $(TEMP_DIR)
	tar -xzvf $(PKG_INSTALL_DIR)/$(TAR_FILE) -C $(TEMP_DIR) --strip-components=1

install:
	@echo "Installing $(BIN_NAME) to $(INSTALL_DIR)..."
	mkdir -p $(call INSTALL_DIR,$(1))
	cp $(TEMP_DIR)/$(BIN_NAME) $(call INSTALL_DIR,$(1))

clean:
	@echo "Cleaning up..."
	rm -rf $(PKG_INSTALL_DIR)

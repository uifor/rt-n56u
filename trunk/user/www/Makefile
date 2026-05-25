ifndef ROOTDIR
ROOTDIR=../..
endif

ROMFS_DIR = $(ROOTDIR)/romfs

include $(ROOTDIR)/user/shared/boards.mk

PROJECT_HOME_URL="https:\/\/bitbucket.org\/padavan\/rt-n56u\/"
PROJECT_HOME_URL_MOD="https:\/\/github.com\/hanwckf\/rt-n56u\/"

LABEL_COPYRIGHT_TEXT='© 2011-2021 <a href="https:\/\/bitbucket.org\/padavan\/rt-n56u" target="blank">Padavan<\/a> \& N56U project community \& by <a href="https:\/\/github.com\/hanwckf\/rt-n56u" target="blank">hanwckf<\/a>'

BOARD_PATTERN=s/ZVMODELVZ/$(CONFIG_FIRMWARE_PRODUCT_ID)/g
COPYR_PATTERN=s/ZVCOPYRVZ/$(LABEL_COPYRIGHT_TEXT)/g
DWURL_PATTERN=s/ZVDWURLVZ/$(PROJECT_HOME_URL)/g
DWURL_MOD_PATTERN=s/ZVMODWURLVZ/$(PROJECT_HOME_URL_MOD)/g
SED_REPLACE=perl -pi -e

WEBUI_NAME ?= n56u_ribbon_fixed

all:

romfs:
	echo "Make www romfs"
	mkdir -p $(ROMFS_DIR)
	rm -Rf $(ROMFS_DIR)/www
	cp -R $(WEBUI_NAME) $(ROMFS_DIR)/www
	rm -f $(ROMFS_DIR)/www/httpd_check.htm
	echo "ASUSTeK" > $(ROMFS_DIR)/www/httpd_check.htm
	cd $(ROMFS_DIR)/www && ln -sf /opt/share/www/custom custom
	cp dict/EN.header $(ROMFS_DIR)/www
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_BR),y)
	echo "LANG_BR=Brazil" >> $(ROMFS_DIR)/www/EN.header
	cp dict/BR.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/BR.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/BR.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/BR.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_CZ),y)
	echo "LANG_CZ=Česky" >> $(ROMFS_DIR)/www/EN.header
	cp dict/CZ.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/CZ.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/CZ.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/CZ.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_DA),y)
	echo "LANG_DA=Dansk" >> $(ROMFS_DIR)/www/EN.header
	cp dict/DA.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/DA.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/DA.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/DA.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_DE),y)
	echo "LANG_DE=Deutsch" >> $(ROMFS_DIR)/www/EN.header
	cp dict/DE.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/DE.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/DE.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/DE.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_ES),y)
	echo "LANG_ES=Español" >> $(ROMFS_DIR)/www/EN.header
	cp dict/ES.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/ES.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/ES.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/ES.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_FI),y)
	echo "LANG_FI=Finsk" >> $(ROMFS_DIR)/www/EN.header
	cp dict/FI.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/FI.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/FI.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/FI.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_FR),y)
	echo "LANG_FR=Français" >> $(ROMFS_DIR)/www/EN.header
	cp dict/FR.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/FR.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/FR.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/FR.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_NO),y)
	echo "LANG_NO=Norsk" >> $(ROMFS_DIR)/www/EN.header
	cp dict/NO.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/NO.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/NO.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/NO.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_PL),y)
	echo "LANG_PL=Polski" >> $(ROMFS_DIR)/www/EN.header
	cp dict/PL.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/PL.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/PL.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/PL.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_RU),y)
	echo "LANG_RU=Pусский" >> $(ROMFS_DIR)/www/EN.header
	cp dict/RU.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/RU.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/RU.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/RU.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_SV),y)
	echo "LANG_SV=Svensk" >> $(ROMFS_DIR)/www/EN.header
	cp dict/SV.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/SV.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/SV.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/SV.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_UK),y)
	echo "LANG_UK=Українська" >> $(ROMFS_DIR)/www/EN.header
	cp dict/UK.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/UK.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/UK.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/UK.dict
endif
ifeq ($(CONFIG_FIRMWARE_INCLUDE_LANG_CN),y)
	echo "LANG_CN=简体中文" >> $(ROMFS_DIR)/www/EN.header
	cp dict/CN.dict $(ROMFS_DIR)/www
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/CN.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/CN.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/CN.dict
	$(SED_REPLACE) $(DWURL_MOD_PATTERN) $(ROMFS_DIR)/www/CN.dict
endif
	cat $(ROMFS_DIR)/www/EN.header dict/EN.footer > $(ROMFS_DIR)/www/EN.dict
	$(SED_REPLACE) $(BOARD_PATTERN) $(ROMFS_DIR)/www/EN.dict
	$(SED_REPLACE) $(COPYR_PATTERN) $(ROMFS_DIR)/www/EN.dict
	$(SED_REPLACE) $(DWURL_PATTERN) $(ROMFS_DIR)/www/EN.dict
	$(SED_REPLACE) $(DWURL_MOD_PATTERN) $(ROMFS_DIR)/www/EN.dict
	rm -f $(ROMFS_DIR)/www/EN.header
	rm -f $(ROMFS_DIR)/www/bootstrap/js/bootstrap.js
	rm -f $(ROMFS_DIR)/www/bootstrap/js/engage.itoggle.js
	rm -f $(ROMFS_DIR)/www/bootstrap/js/jquery.backgroundpos.min.js
	rm -f $(ROMFS_DIR)/www/bootstrap/js/jquery.easing.1.3.js
	rm -f $(ROMFS_DIR)/www/bootstrap/css/bootstrap.css
ifeq ($(BOARD_HAS_2G_RADIO),0)
	rm -f $(ROMFS_DIR)/www/Advanced_ACL2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WAdvanced2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WGuest2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_Wireless2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WMode2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WSecurity2g_Content.asp
	rm -f $(ROMFS_DIR)/www/Main_WStatus2g_Content.asp
	rm -f $(ROMFS_DIR)/www/wireless_2g.js
	rm -f $(ROMFS_DIR)/www/wds_aplist_2g.asp
	rm -f $(ROMFS_DIR)/www/device-map/router2g.asp
endif
ifeq ($(BOARD_HAS_5G_RADIO),0)
	rm -f $(ROMFS_DIR)/www/Advanced_ACL_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WAdvanced_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WGuest_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_Wireless_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WMode_Content.asp
	rm -f $(ROMFS_DIR)/www/Advanced_WSecurity_Content.asp
	rm -f $(ROMFS_DIR)/www/Main_WStatus_Content.asp
	rm -f $(ROMFS_DIR)/www/wireless.js
	rm -f $(ROMFS_DIR)/www/wds_aplist.asp
	rm -f $(ROMFS_DIR)/www/device-map/router.asp
endif
ifndef CONFIG_IPV6
	rm -f $(ROMFS_DIR)/www/Advanced_IPv6_Content.asp
endif
ifndef CONFIG_ATA
	rm -f $(ROMFS_DIR)/www/device-map/sata.asp
endif
ifndef CONFIG_USB_SUPPORT
	rm -f $(ROMFS_DIR)/www/Advanced_Modem_others.asp
	rm -f $(ROMFS_DIR)/www/Advanced_Printer_others.asp
	rm -f $(ROMFS_DIR)/www/modem_isp.js
	rm -f $(ROMFS_DIR)/www/device-map/modem.asp
	rm -f $(ROMFS_DIR)/www/device-map/printer.asp
	rm -f $(ROMFS_DIR)/www/device-map/hub.asp
endif
ifneq ($(STORAGE_ENABLED),y)
	rm -f $(ROMFS_DIR)/www/Advanced_AiDisk_ftp.asp
	rm -f $(ROMFS_DIR)/www/Advanced_AiDisk_others.asp
	rm -f $(ROMFS_DIR)/www/Advanced_AiDisk_samba.asp
	rm -f $(ROMFS_DIR)/www/aidisk.asp
	rm -f $(ROMFS_DIR)/www/disk_folder_tree.js
	rm -f $(ROMFS_DIR)/www/device-map/disk.asp
	rm -f $(ROMFS_DIR)/www/device-map/safely_remove_disk.asp
	rm -rf $(ROMFS_DIR)/www/aidisk
	rm -rf $(ROMFS_DIR)/www/images/AiDisk
	rm -rf $(ROMFS_DIR)/www/images/Tree
endif
ifneq ($(CONFIG_FIRMWARE_INCLUDE_SCUTCLIENT),y)
	rm -f $(ROMFS_DIR)/www/scutclient.asp
	rm -f $(ROMFS_DIR)/www/scutclient_log.asp
	rm -f $(ROMFS_DIR)/www/scutclient_action.asp
endif
ifneq ($(CONFIG_FIRMWARE_INCLUDE_MENTOHUST),y)
	rm -f $(ROMFS_DIR)/www/mentohust.asp
	rm -f $(ROMFS_DIR)/www/mentohust_log.asp
	rm -f $(ROMFS_DIR)/www/mentohust_action.asp
endif
ifneq ($(CONFIG_FIRMWARE_INCLUDE_DNSFORWARDER),y)
	rm -f $(ROMFS_DIR)/www/dns-forwarder.asp
endif
ifneq ($(CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS),y)
	rm -f $(ROMFS_DIR)/www/Shadowsocks.asp
	rm -f $(ROMFS_DIR)/www/Shadowsocks_action.asp
	rm -f $(ROMFS_DIR)/www/Shadowsocks_log.asp
endif

clean:
	@echo "Clean www romfs"

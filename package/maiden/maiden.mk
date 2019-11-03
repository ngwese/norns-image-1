################################################################################
#
# maiden (pre-built)
#
################################################################################

MAIDEN_VERSION = v1.0
MAIDEN_SOURCE = maiden-$(MAIDEN_VERSION).tgz
MAIDEN_SITE = https://github.com/monome/maiden/releases/download/$(MAIDEN_VERSION)
MAIDEN_LICENSE = GPL-3.0
MAIDEN_LICENSE_FILES = LICENSE.txt
MAIDEN_DEPENDENCIES = dust ca-certificates

define MAIDEN_INSTALL_TARGET_CMDS
	# executable
	cp -av $(@D)/maiden $(TARGET_DIR)/bin/maiden
	# app
	mkdir -p $(TARGET_DIR)/usr/share/maiden
	cp -av $(@D)/app/build $(TARGET_DIR)/usr/share/maiden/app
	# config
	cp -av $(MAIDEN_PKGDIR)/maiden.yaml $(TARGET_DIR)/etc
	# sources
	mkdir -pv $(TARGET_DIR)/root/dust/data/{sources,catalogs}
	cp -av $(@D)/dist/sources/*.json $(TARGET_DIR)/root/dust/data/sources/

endef

$(eval $(generic-package))

################################################################################
#
# norns
#
################################################################################

#NORNS_VERSION = v2.0.1
NORNS_VERSION = 367c7904157d0ade348e0aa50a8d9321b8fda28a
NORNS_SITE = $(call github,ngwese,norns,$(NORNS_VERSION))
NORNS_LICENSE = ISC
NORNS_LICENSE_FILES = LICENSE.txt
NORNS_INSTALL_STAGING = YES
NORNS_CONF_OPTS = --boost-includes=$(STAGING_DIR)/usr/include --boost-libs $(STAGING_DIR)/usr/lib
NORNS_DEPENDENCIES = avahi boost cairo libevdev liblo libmonome lua nanomsg supercollider

$(eval $(waf-package))

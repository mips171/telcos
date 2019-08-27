#
# Copyright (C) 2016 Velocloud Inc.
# Copyright (C) 2016 Aleksander Morgado <aleksander@aleksander.es>
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmbim
PKG_VERSION:=1.18.3
PKG_RELEASE:=1

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
#PKG_SOURCE_URL:=https://www.freedesktop.org/software/libmbim
#PKG_HASH=7723f2ca2286c5286ffba7331cb4520099982e55355a7af6f45bdce6b5d39268

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git://anongit.freedesktop.org/libmbim/libmbim
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=47cf7e1aebb3d0ccd95c0e88a30df68bf6dfc0f4
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz


PKG_MAINTAINER:=Nicholas Smith <nicholas.smith@telcoantennas.com.au>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING COPYING.LIB

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/libmbim
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+glib2
  TITLE:=Helper library and utils to talk to MBIM enabled modems
  URL:=https://www.freedesktop.org/wiki/Software/libmbim
endef

define Package/libmbim/description
  Helper library to talk to MBIM enabled modems.
  Add mbim-utils for extra utilities.
endef

define Package/mbim-utils
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libmbim
  TITLE:=Utilities to talk to MBIM enabled modems
  URL:=https://www.freedesktop.org/wiki/Software/libmbim
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/libmbim-glib \
		$(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.{so*,la} \
		$(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/mbim-glib.pc \
		$(1)/usr/lib/pkgconfig
endef

define Package/libmbim/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.so.* \
		$(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/mbim-proxy $(1)/usr/lib/
endef

define Package/mbim-utils/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mbimcli $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mbim-network $(1)/usr/bin/
endef

$(eval $(call BuildPackage,libmbim))
$(eval $(call BuildPackage,mbim-utils))

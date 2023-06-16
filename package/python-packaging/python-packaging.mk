################################################################################
#
# python-packaging
#
################################################################################

PYTHON_PACKAGING_VERSION = 23.1
PYTHON_PACKAGING_SOURCE = packaging-$(PYTHON_PACKAGING_VERSION)-py3-none-any.whl
PYTHON_PACKAGING_SITE = https://files.pythonhosted.org/packages/ab/c3/57f0601a2d4fe15de7a553c00adbc901425661bf048f2a22dfc500caf121
PYTHON_PACKAGING_LICENSE = Apache-2.0
PYTHON_PACKAGING_LICENSE_FILES = LICENSE.APACHE
# PYTHON_PACKAGING_SETUP_TYPE = distutils

# $(eval $(python-package))

define PYTHON_PACKAGING_EXTRACT_CMDS
	unzip $(PYTHON_PACKAGING_DL_DIR)/$(PYTHON_PACKAGING_SOURCE) -d $(@D)
endef

define HOST_PYTHON_PACKAGING_INSTALL_CMDS
	$(HOST_MAKE_ENV) cd $(@D) ;\
	rsync -au packaging* $(STAGING_DIR)$(PKG_INSTALL_PREFIX)/lib/python3.8/site-packages/
endef

define PYTHON_PACKAGING_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) cd $(@D) ;\
	rsync -au packaging* $(TARGET_DIR)$(PKG_INSTALL_PREFIX)/lib/python3.8/site-packages/
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
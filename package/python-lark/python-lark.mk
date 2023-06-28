################################################################################
#
# python-lark
#
################################################################################

PYTHON_LARK_VERSION = 1.1.5
PYTHON_LARK_SOURCE = lark-$(PYTHON_LARK_VERSION).tar.gz
PYTHON_LARK_SITE = https://files.pythonhosted.org/packages/a2/25/8e16de418fc83bb00dabaf8c7110bc45a90bf5481a70aa5f1668fcea73bc
PYTHON_LARK_LICENSE = None
PYTHON_LARK_LICENSE_FILES = LICENSE.txt
PYTHON_LARK_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))

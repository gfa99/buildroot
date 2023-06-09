################################################################################
#
# libasio
#
################################################################################

LIBASIO_VERSION = 1.12.2
LIBASIO_SOURCE = asio-$(LIBASIO_VERSION).tar.bz2
LIBASIO_SITE = http://downloads.sourceforge.net/project/asio/asio/$(LIBASIO_VERSION)%20%28Stable%29
LIBASIO_AUTORECONF = YES
LIBASIO_INSTALL_STAGING = YES
LIBASIO_LICENSE = BSL-1.0
LIBASIO_LICENSE_FILES = LICENSE_1_0.txt

LIBASIO_DEPENDENCIES = boost

$(eval $(autotools-package))

# INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NetSwitch

export ARCHS = armv7 armv7s arm64 arm64e
export TARGET = iphone:clang:13.0:10.0

NetSwitch_FILES = Tweak.xm
NetSwitch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += prefers
include $(THEOS_MAKE_PATH)/aggregate.mk

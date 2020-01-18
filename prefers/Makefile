include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = prefers

prefers_FILES = NSRootListController.m
prefers_INSTALL_PATH = /Library/PreferenceBundles
prefers_FRAMEWORKS = UIKit
prefers_PRIVATE_FRAMEWORKS = Preferences CoreServices
prefers_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/prefers.plist$(ECHO_END)

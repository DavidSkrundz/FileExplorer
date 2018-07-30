include $(THEOS)/makefiles/common.mk

export ARCHS=arm64
export TARGET=iphone:latest:11.0

APPLICATION_NAME = FileExplorer
APPLICATION_DIR = $(THEOS_STAGING_DIR)/Applications/$(APPLICATION_NAME).app/
FileExplorer_FILES = $(wildcard src/*.swift)
FileExplorer_ASSETS = $(wildcard Resources/*.xcassets)
FileExplorer_STORYBOARDS = $(wildcard Resources/*.storyboard)
FileExplorer_RESOURCE_DIRS = Assets
FileExplorer_CODESIGN_FLAGS = -SResources/Entitlements.xml

include $(THEOS_MAKE_PATH)/application.mk

release: FINALPACKAGE=1
release: package

after-stage::
	$(ECHO_NOTHING)chmod +s $(APPLICATION_DIR)$(APPLICATION_NAME)$(ECHO_END)

after-install::
	install.exec "killall \"FileExplorer\"" || true



_ASSETS_FILES :=

define ASSET_FILE_TEMPLATE
_ASSETS_FILES += $(APPLICATION_DIR)$(patsubst %.xcassets,%.car,$(notdir $(1)))
$(THEOS_OBJ_DIR)/$(patsubst %.xcassets,%.car,$(notdir $(1))): $(1)
	$$(ECHO_COMPILING)xcrun actool $$< --errors --warnings --notices --compile $$(dir $$@) --platform iphoneos --minimum-deployment-target 11.0 --app-icon AppIcon --output-partial-info-plist $$(THEOS_OBJ_DIR)/$$(subst /,_,$(1)).plist >/dev/null$$(ECHO_END)
$(APPLICATION_DIR)$(patsubst %.xcassets,%.car,$(notdir $(1))): $(THEOS_OBJ_DIR)/$(patsubst %.xcassets,%.car,$(notdir $(1)))
	$(ECHO_NOTHING)cp $$< $$@$(ECHO_END)
endef

$(foreach asset_file,$($(APPLICATION_NAME)_ASSETS),$(eval $(call ASSET_FILE_TEMPLATE,$(asset_file))))

stage:: $(_ASSETS_FILES)



_STORYBOARD_FILES :=

define STORYBOARD_FILE_TEMPLATE
_STORYBOARD_FILES += $(APPLICATION_DIR)$(patsubst %.storyboard,%.storyboardc,$(notdir $(1)))
$(THEOS_OBJ_DIR)/$(patsubst %.storyboard,%.storyboardc,$(notdir $(1))): $(1)
	$$(ECHO_COMPILING)xcrun ibtool --errors --warnings --notices --module $$(APPLICATION_NAME) --auto-activate-custom-fonts --target-device iphone --target-device ipad --minimum-deployment-target 11.0 --output-format human-readable-text --compilation-directory $$(dir $$@) $$<$$(ECHO_END)
$(APPLICATION_DIR)$(patsubst %.storyboard,%.storyboardc,$(notdir $(1))): $(THEOS_OBJ_DIR)/$(patsubst %.storyboard,%.storyboardc,$(notdir $(1)))
	$(ECHO_NOTHING)xcrun ibtool --errors --warnings --notices --module $$(APPLICATION_NAME) --target-device iphone --target-device ipad --minimum-deployment-target 11.0 --output-format human-readable-text --link $(APPLICATION_DIR) $$<$(ECHO_END)
endef

$(foreach storyboard_file,$($(APPLICATION_NAME)_STORYBOARDS),$(eval $(call STORYBOARD_FILE_TEMPLATE,$(storyboard_file))))

stage:: $(_STORYBOARD_FILES)

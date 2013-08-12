ifeq ($(BOARD_VENDOR),samsung)
ifeq ($(TARGET_BOARD_PLATFORM),msm8960)

LOCAL_PATH := $(call my-dir)

FEATURE_IPV6 := true
FEATURE_DELEXT := true

include $(call all-subdir-makefiles,$(LOCAL_PATH))

endif
endif

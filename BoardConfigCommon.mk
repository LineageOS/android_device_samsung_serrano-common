# Copyright (C) 2013-2016, The CyanogenMod Project
# Copyright (C) 2017, The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# Inherit from common msm8930
-include $(PLATFORM_PATH)/BoardConfigCommon.mk

# Inherit from proprietary vendor
-include $(COMMON_VENDOR_PATH)/BoardConfigVendor.mk

# Includes
TARGET_SPECIFIC_HEADER_PATH += $(COMMON_PATH)/include

# The first api level the device has commercially launched on
PRODUCT_SHIPPING_API_LEVEL := 19

# Manifests
DEVICE_FRAMEWORK_MANIFEST_FILE := system/libhidl/vintfdata/manifest_healthd_exclude.xml
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml

# Set default locale
PRODUCT_LOCALES := en-GB

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom user_debug=22 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=msm_sdcc.1
BOARD_KERNEL_BASE := 0x80200000
BOARD_KERNEL_IMAGE_NAME := zImage
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02000000
BOARD_KERNEL_PAGESIZE := 2048
TARGET_KERNEL_SOURCE := kernel/samsung/msm8930-common
ifneq ($(filter serranoltespr serranolteusc,$(TARGET_DEVICE)),)
TARGET_KERNEL_CONFIG := samsung_serrano_usa_defconfig
else
TARGET_KERNEL_CONFIG := samsung_serrano_defconfig
endif

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8960

# Recovery
LZMA_RAMDISK_TARGETS := recovery
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/fstab.qcom

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 10485760
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 10485760
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1572864000
BOARD_SYSTEMIMAGE_JOURNAL_SIZE := 0
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5821660160
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_ROOT_EXTRA_FOLDERS := efs firmware persist
BOARD_ROOT_EXTRA_SYMLINKS := /data/tombstones:/tombstones

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth

# Audio
USE_XML_AUDIO_POLICY_CONF := 1

# FM
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
BOARD_HAVE_QCOM_FM := true
TARGET_FM_LEGACY_PATCHLOADER := true

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true

# Camera
TARGET_NEED_CAMERA_ZSL := true
TARGET_NEED_FFC_PICTURE_FIXUP := true
TARGET_NEED_FFC_VIDEO_FIXUP := true
TARGET_NEED_DISABLE_FACE_DETECTION := true
TARGET_NEED_DISABLE_FACE_DETECTION_BOTH_CAMERAS := true

# RIL
BOARD_PROVIDES_LIBRIL := true
TARGET_RIL_VARIANT := caf

# Legacy blobs
TARGET_PROCESS_SDK_VERSION_OVERRIDE += \
    /system/vendor/bin/hw/rild=27

# Network Routing
TARGET_NEEDS_NETD_DIRECT_CONNECT_RULE := true

# Vendor init
TARGET_INIT_VENDOR_LIB := libinit_serrano
TARGET_RECOVERY_DEVICE_MODULES := libinit_serrano

ifeq ($(WITH_TWRP),true)
-include $(COMMON_PATH)/twrp.mk
endif

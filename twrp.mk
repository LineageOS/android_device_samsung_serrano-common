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

BOARD_HAS_NO_REAL_SDCARD := true
DEVICE_RESOLUTION := 540x960
LZMA_RAMDISK_TARGETS := boot,recovery
RECOVERY_SDCARD_ON_DATA := true
RECOVERY_VARIANT := twrp
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
TW_EXTRA_LANGUAGES := false
TW_HAS_DOWNLOAD_MODE := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_MAX_BRIGHTNESS := 255
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_USB_STORAGE := true
TW_TARGET_USES_QCOM_BSP := true
TW_USE_TOOLBOX := true

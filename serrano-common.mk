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

# Also get non-open-source specific aspects
$(call inherit-product, vendor/samsung/serrano-common/serrano-common-vendor.mk)

# Common overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/serrano-common/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 960
TARGET_SCREEN_WIDTH := 540

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# Media Profile
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/media/media_codecs_google_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_performance.xml \
    $(LOCAL_PATH)/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/pmic8xxx_pwrkey.kl:system/usr/keylayout/pmic8xxx_pwrkey.kl \
    $(LOCAL_PATH)/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.qcom:root/fstab.qcom \
    $(LOCAL_PATH)/rootdir/init.qcom.power.rc:root/init.qcom.power.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.power.rc:root/init.recovery.qcom.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.rc:root/init.qcom.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.usb.rc:root/init.qcom.usb.rc \
    $(LOCAL_PATH)/rootdir/init.target.rc:root/init.target.rc \
    $(LOCAL_PATH)/rootdir/ueventd.qcom.rc:root/ueventd.qcom.rc

# Etc scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/vendor/bin/init.qcom.audio.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.audio.sh \
    $(LOCAL_PATH)/rootdir/vendor/bin/init.qcom.bt.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.bt.sh \
    $(LOCAL_PATH)/rootdir/vendor/bin/init.qcom.fm.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.fm.sh

# GPS/location security configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/vendor/etc/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# Prima opensource driver files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prima/WCNSS_cfg.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/prima/WCNSS_cfg.dat \
    $(LOCAL_PATH)/prima/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/prima/WCNSS_qcom_wlan_nv.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin

# Custom wifi service
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/vendor/etc/init/android.hardware.wifi@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.wifi@1.0-service.rc

# Thermal profile
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/vendor/etc/thermald.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermald.conf

# GPS HAL
PRODUCT_PACKAGES += \
    gps.msm8960 \
    gps.conf

# IR package
PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-impl \
    consumerir.msm8960

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.serrano

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-service.serrano

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.serrano

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.1-service.serrano

# Touch
PRODUCT_PACKAGES += \
    vendor.lineage.touch@1.0-service.serrano

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service.serrano

# Health HAL
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.serrano

# IPv6 tethering
PRODUCT_PACKAGES += \
    ebtables

# F2FS
PRODUCT_PACKAGES += \
    fsck.f2fs \
    mkfs.f2fs

# Doze
PRODUCT_PACKAGES += \
    SamsungDoze

# Camera
PRODUCT_PACKAGES += \
    Snap

# FlipFlap
PRODUCT_PACKAGES += \
    FlipFlap

# Telephony
PRODUCT_PACKAGES += \
    libsecnativefeature

# call common serrano system props
$(call inherit-product, device/samsung/serrano-common/system_prop.mk)

# call common serrano system debug props
#$(call inherit-product, device/samsung/serrano-common/system_prop_debug.mk)

# call common msm8930
$(call inherit-product, device/samsung/msm8930-common/msm8930.mk)

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

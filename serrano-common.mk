# Copyright (C) 2013 The CyanogenMod Project
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

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Also get non-open-source specific aspects if available
$(call inherit-product-if-exists, vendor/samsung/serrano-common/serrano-common-vendor.mk)

# Common overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/serrano-common/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 960
TARGET_SCREEN_WIDTH := 540

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/snd_soc_msm_2x:system/etc/snd_soc_msm/snd_soc_msm_2x

# Media Profile
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_ffmpeg.xml:system/etc/media_codecs_ffmpeg.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_profiles.xml:system/etc/media_profiles.xml

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/atmel_mxt_ts.kl:system/usr/keylayout/atmel_mxt_ts.kl \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/philips_remote_ir.kl:system/usr/keylayout/philips_remote_ir.kl \
    $(LOCAL_PATH)/keylayout/samsung_remote_ir.kl:system/usr/keylayout/samsung_remote_ir.kl \
    $(LOCAL_PATH)/keylayout/sec_keys.kl:system/usr/keylayout/sec_keys.kl \
    $(LOCAL_PATH)/keylayout/sec_powerkey.kl:system/usr/keylayout/sec_powerkey.kl \
    $(LOCAL_PATH)/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl \
    $(LOCAL_PATH)/keylayout/sii9234_rcp.kl:system/usr/keylayout/sii9234_rcp.kl \
    $(LOCAL_PATH)/keylayout/ue_rf4ce_remote.kl:system/usr/keylayout/ue_rf4ce_remote.kl

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.qcom:root/fstab.qcom \
    $(LOCAL_PATH)/rootdir/init.qcom.power.rc:root/init.qcom.power.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.rc:root/init.qcom.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.syspart_fixup.sh:root/init.qcom.syspart_fixup.sh \
    $(LOCAL_PATH)/rootdir/init.qcom.usb.rc:root/init.qcom.usb.rc \
    $(LOCAL_PATH)/rootdir/init.target.rc:root/init.target.rc \
    $(LOCAL_PATH)/rootdir/ueventd.qcom.rc:root/ueventd.qcom.rc

# Etc scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/etc/init.crda.sh:system/etc/init.crda.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.audio.sh:system/etc/init.qcom.audio.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.fm.sh:system/etc/init.qcom.fm.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.modem_links.sh:system/etc/init.qcom.modem_links.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.thermal_conf.sh:system/etc/init.qcom.thermal_conf.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.wifi.sh:system/etc/init.qcom.wifi.sh

# GPS HAL
PRODUCT_PACKAGES += \
    gps.msm8960

# GPS config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/configs/sap.conf:system/etc/sap.conf

# FM radio
PRODUCT_PACKAGES += \
    qcom.fmradio \
    libqcomfm_jni \
    FM2 \
    FMRecord

# Torch
PRODUCT_PACKAGES += \
    Torch

# Lights
PRODUCT_PACKAGES += \
    lights.msm8960

# IR package
PRODUCT_PACKAGES += \
    consumerir.msm8960

# IPv6 tethering
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes

# IR feature permission
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml

# GPS/location security configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:system/etc/sec_config

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/lib/libqc-opt.so

# Common build props
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product_ship=true \
    wifi.interface=wlan0 \
    ro.chipname=MSM8930AB \
    ro.config.ehrpd=true \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    persist.radio.add_power_save=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.eons.enabled=true \
    persist.radio.fill_eons=1 \
    persist.radio.prefer_spn=0 \
    persist.data.netmgrd.qos.enable=false \
    ro.sf.lcd_density=240 \
    ro.ril.transmitpower=true \
    ro.warmboot.capability=1 \
    ro.qualcomm.cabl=0 \
    debug.composition.type=c2d \
    ro.opengles.version=196608 \
    mm.enable.qcom_parser=33395 \
    persist.audio.fluence.mode=endfire \
    persist.audio.vr.enable=false \
    persist.audio.handset.mic=digital \
    lpa.decode=true \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3="" \
    ril.subscription.types=NV,RUIM \
    persist.gps.qmienabled=true \
    persist.gps.qc_nlp_in_use=1 \
    ro.qc.sdk.izat.premium_enabled=0 \
    ro.qc.sdk.izat.service_mask=0x0 \
    ro.gps.agps_provider=1 \
    persist.fuse_sdcard=true \
    ro.vold.umsdirtyratio=50 \
    ro.cwm.enable_key_repeat=true \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    persist.timed.enable=true \
    persist.audio.lowlatency.rec=false \
    audio.gapless.playback.disable=true \
    qcom.hw.aac.encoder=true \
    ro.config.max_starting_bg=8

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.ril_class=SerranoRIL

# call common msm8930
$(call inherit-product, device/samsung/msm8930-common/msm8930.mk)

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

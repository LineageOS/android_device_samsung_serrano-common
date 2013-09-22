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

# Overlays
DEVICE_PACKAGE_OVERLAYS += device/samsung/serrano-common/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 960
TARGET_SCREEN_WIDTH := 540

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/snd_soc_msm_2x:system/etc/snd_soc_msm/snd_soc_msm_2x

# Media Profile
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_profiles.xml:system/etc/media_profiles.xml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8960 \
    gps.conf \
    sap.conf

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
    $(LOCAL_PATH)/rootdir/charger:root/charger \
    $(LOCAL_PATH)/rootdir/charger:recovery/root/charger \
    $(LOCAL_PATH)/rootdir/fstab.qcom:root/fstab.qcom \
    $(LOCAL_PATH)/rootdir/fstab.qcom:recovery/root/fstab.qcom \
    $(LOCAL_PATH)/rootdir/lpm.rc:root/lpm.rc \
    $(LOCAL_PATH)/rootdir/lpm.rc:recovery/root/lpm.rc \
    $(LOCAL_PATH)/rootdir/init.carrier.rc:root/init.carrier.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.rc:root/init.qcom.rc \
    $(LOCAL_PATH)/rootdir/init.qcom.usb.rc:root/init.qcom.usb.rc \
    $(LOCAL_PATH)/rootdir/init.target.rc:root/init.target.rc \
    $(LOCAL_PATH)/rootdir/ueventd.qcom.rc:root/ueventd.qcom.rc

# Etc scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.audio.sh:system/etc/init.qcom.audio.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.fm.sh:system/etc/init.qcom.fm.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.mdm_links.sh:system/etc/init.qcom.mdm_links.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.modem_links.sh:system/etc/init.qcom.modem_links.sh \
    $(LOCAL_PATH)/rootdir/system/etc/init.qcom.wifi.sh:system/etc/init.qcom.wifi.sh

# Vold configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vold.fstab:system/etc/vold.fstab

# Torch
PRODUCT_PACKAGES += Torch

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# Lights
PRODUCT_PACKAGES += lights.msm8960

# Increase the HWUI font cache since we have tons of RAM
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hwui.text_cache_width=2048

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/system/lib/libqc-opt.so

# QRNGD
PRODUCT_PACKAGES += qrngd

#common build.props
PRODUCT_PROPERTY_OVERRIDES += \
    ro.chipname=MSM8930AB \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    persist.radio.add_power_save=1 \
    persist.radio.dont_use_dsd=true \
    persist.radio.apm_sim_not_pwdn=1 \
    ro.qualcomm.bt.hci_transport=smd \
    ro.sf.lcd_density=240 \
    ro.ril.transmitpower=true \
    ro.warmboot.capability=1 \
    ro.qualcomm.cabl=0 \
    ro.opengles.version=131072 \
    debug.gr.numframebuffers=3 \
    af.resampler.quality=255 \
    persist.audio.fluence.mode=endfire \
    persist.audio.vr.enable=false \
    persist.audio.handset.mic=digital \
    ro.use_data_netmgrd=true \
    lpa.decode=true \
    lpa.use-stagefright=true \
    rild.libpath=/system/lib/libril-qc-qmi-1.so \
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
    persist.gps.qc_nlp_in_use=0 \
    persist.fuse_sdcard=true

# For userdebug builds
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0

# call common msm8930
$(call inherit-product, device/samsung/msm8930-common/msm8930.mk)

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

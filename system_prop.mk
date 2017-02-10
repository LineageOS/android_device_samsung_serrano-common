# Set composition for USB
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.android.mobiledata=false \
    ro.telephony.ril_class=SerranoRIL \
    ro.ril.telephony.mqanelements=6 \
    persist.radio.add_power_save=1

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qmienabled=true \
    persist.gps.qc_nlp_in_use=1 \
    ro.qc.sdk.izat.premium_enabled=0 \
    ro.qc.sdk.izat.service_mask=0x0 \
    ro.gps.agps_provider=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.disable=1 \
    mm.enable.smoothstreaming=true \
    use.dedicated.device.for.voip=true \
    use.voice.path.for.pcm.voip=true \
    media.aac_51_output_enabled=true \
    media.stagefright.legacyencoder=true \
    media.stagefright.less-secure=true \
    persist.bluetooth.disableabsvol=true

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    debug.composition.type=c2d \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    ro.sf.lcd_density=240 \
    ro.opengles.version=196608 \
    ro.qualcomm.cabl=0 \
    ro.hwui.text_large_cache_height=2048

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

# Misc
PRODUCT_PROPERTY_OVERRIDES += \
    ro.chipname=MSM8930AB \
    ro.product_ship=true \
    ro.warmboot.capability=1 \
    persist.timed.enable=true \
    wifi.interface=wlan0 \
    ro.qualcomm.bt.hci_transport=smd \
    qcom.bluetooth.soc=smd

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-swap=false \
    ro.am.reschedule_service=true \
    ro.sys.fw.dex2oat_thread_count=4

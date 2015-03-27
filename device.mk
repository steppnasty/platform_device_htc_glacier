#
# Copyright (C) 2011 The CyanogenMod Project
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

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
PRODUCT_COPY_FILES += \
    device/htc/glacier/gps.conf:system/etc/gps.conf

## (1) First, the most specific values, i.e. the aspects that are specific to GSM

PRODUCT_COPY_FILES += \
    device/htc/glacier/init.glacier.rc:root/init.glacier.rc \
    device/htc/glacier/ueventd.glacier.rc:root/ueventd.glacier.rc

## (2) Also get non-open-source GSM-specific aspects if available
$(call inherit-product-if-exists, vendor/htc/glacier/device-vendor.mk)

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1 \
    ro.com.google.gmsversion=2.3_r3 \
    ro.setupwizard.enable_bypass=1 \
    dalvik.vm.lockprof.threshold=500 \
    dalvik.vm.dexopt-flags=m=y \
    persist.hwc.mdpcomp.enable=true

# Override /proc/sys/vm/dirty_ratio on UMS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vold.umsdirtyratio=20

DEVICE_PACKAGE_OVERLAYS += device/htc/glacier/overlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \

# gsm config xml file
PRODUCT_COPY_FILES += \
    device/htc/glacier/voicemail-conf.xml:system/etc/voicemail-conf.xml

# Sensors, GPS, Lights
PRODUCT_PACKAGES += \
    gps.glacier \
    lights.glacier \
    sensors.glacier

# idc files
PRODUCT_COPY_FILES += \
    device/htc/glacier/idc/atmel-touchscreen.idc:system/usr/idc/atmel-touchscreen.idc \
    device/htc/glacier/idc/qwerty.idc:system/usr/idc/qwerty.idc \
    device/htc/glacier/idc/qwerty2.idc:system/usr/idc/qwerty2.idc \
    device/htc/glacier/idc/synaptics-rmi-touchscreen.idc:system/usr/idc/synaptics-rmi-touchscreen.idc \
    device/htc/glacier/idc/curcial-oj.idc:system/usr/idc/curcial-oj.idc 

# Keychars
PRODUCT_COPY_FILES += \
    device/htc/glacier/keychars/synaptics-rmi-touchscreen.kcm.bin:system/usr/keychars/synaptics-rmi-touchscreen.kcm.bin \
    device/htc/glacier/keychars/qwerty2.kcm.bin:system/usr/keychars/qwerty2.kcm.bin \
    device/htc/glacier/keychars/qwerty2.kcm:system/usr/keychars/qwerty2.kcm \
    device/htc/glacier/keychars/qwerty.kcm.bin:system/usr/keychars/qwerty.kcm.bin \
    device/htc/glacier/keychars/qwerty.kcm:system/usr/keychars/qwerty.kcm \
    device/htc/glacier/keychars/glacier-keypad.kcm.bin:system/usr/keychars/glacier-keypad.kcm.bin 

# Keylayouts
PRODUCT_COPY_FILES += \
    device/htc/glacier/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/htc/glacier/keylayout/h2w_headset.kl:system/usr/keylayout/h2w_headset.kl \
    device/htc/glacier/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    device/htc/glacier/keylayout/glacier-keypad.kl:system/usr/keylayout/glacier-keypad.kl


# T-MOBILE CERT
PRODUCT_COPY_FILES += \
    device/htc/glacier/prebuilt/etc/T-Mobile_USA_Root_CA.der:system/etc/T-Mobile_USA_Root_CA.der \

# Firmware
PRODUCT_COPY_FILES += \
    device/htc/glacier/firmware/bcm4329.hcd:system/etc/firmware/bcm4329.hcd \
    device/htc/glacier/firmware/fw_bcm4329.bin:/system/vendor/firmware/fw_bcm4329.bin \
    device/htc/glacier/firmware/fw_bcm4329_apsta.bin:/system/vendor/firmware/fw_bcm4329_apsta.bin \
    device/htc/glacier/firmware/fw_bcm4329_p2p.bin:/system/vendor/firmware/fw_bcm4329_p2p.bin \
    device/htc/glacier/firmware/default.acdb:system/etc/firmware/default.acdb \
    device/htc/glacier/firmware/default_org.acdb:system/etc/firmware/default_org.acdb \
    device/htc/glacier/firmware/default_org_WA.acdb:system/etc/firmware/default_org_WA.acdb 

# Audio DSP Profiles
PRODUCT_COPY_FILES += \
    device/htc/glacier/dsp/A1026_CFG.csv:system/etc/A1026_CFG.csv \
    device/htc/glacier/dsp/AIC3254_REG.csv:system/etc/AIC3254_REG.csv \
    device/htc/glacier/dsp/AIC3254_REG_XD.csv:system/etc/AIC3254_REG_XD.csv \
    device/htc/glacier/dsp/AdieHWCodec.csv:system/etc/AdieHWCodec.csv \
    device/htc/glacier/dsp/AdieHWCodec_WA.csv:system/etc/AdieHWCodec_WA.csv \
    device/htc/glacier/dsp/CodecDSPID.txt:system/etc/CodecDSPID.txt \
    device/htc/glacier/dsp/HP_Audio.csv:system/etc/HP_Audio.csv \
    device/htc/glacier/dsp/HP_Video.csv:system/etc/HP_Video.csv \
    device/htc/glacier/dsp/SPK_Combination.csv:system/etc/SPK_Combination.csv \
    device/htc/glacier/dsp/soundimage/Sound_Bass_Booster.txt:system/etc/soundimage/Sound_Bass_Booster.txt \
    device/htc/glacier/dsp/soundimage/Sound_Blues.txt:system/etc/soundimage/Sound_Blues.txt \
    device/htc/glacier/dsp/soundimage/Sound_Classical.txt:system/etc/soundimage/Sound_Classical.txt \
    device/htc/glacier/dsp/soundimage/Sound_Country.txt:system/etc/soundimage/Sound_Country.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dolby_A_HP.txt:system/etc/soundimage/Sound_Dolby_A_HP.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dolby_A_SPK.txt:system/etc/soundimage/Sound_Dolby_A_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dolby_V_HP.txt:system/etc/soundimage/Sound_Dolby_V_HP.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dolby_V_SPK.txt:system/etc/soundimage/Sound_Dolby_V_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dualmic.txt:system/etc/soundimage/Sound_Dualmic.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dualmic_EP.txt:system/etc/soundimage/Sound_Dualmic_EP.txt \
    device/htc/glacier/dsp/soundimage/Sound_Dualmic_SPK.txt:system/etc/soundimage/Sound_Dualmic_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_Jazz.txt:system/etc/soundimage/Sound_Jazz.txt \
    device/htc/glacier/dsp/soundimage/Sound_Latin.txt:system/etc/soundimage/Sound_Latin.txt \
    device/htc/glacier/dsp/soundimage/Sound_New_Age.txt:system/etc/soundimage/Sound_New_Age.txt \
    device/htc/glacier/dsp/soundimage/Sound_Original.txt:system/etc/soundimage/Sound_Original.txt \
    device/htc/glacier/dsp/soundimage/Sound_Original_SPK.txt:system/etc/soundimage/Sound_Original_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_Piano.txt:system/etc/soundimage/Sound_Piano.txt \
    device/htc/glacier/dsp/soundimage/Sound_Pop.txt:system/etc/soundimage/Sound_Pop.txt \
    device/htc/glacier/dsp/soundimage/Sound_R_B.txt:system/etc/soundimage/Sound_R_B.txt \
    device/htc/glacier/dsp/soundimage/Sound_Rock.txt:system/etc/soundimage/Sound_Rock.txt \
    device/htc/glacier/dsp/soundimage/Sound_SRS_A_HP.txt:system/etc/soundimage/Sound_SRS_A_HP.txt \
    device/htc/glacier/dsp/soundimage/Sound_SRS_A_SPK.txt:system/etc/soundimage/Sound_SRS_A_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_SRS_V_HP.txt:system/etc/soundimage/Sound_SRS_V_HP.txt \
    device/htc/glacier/dsp/soundimage/Sound_SRS_V_SPK.txt:system/etc/soundimage/Sound_SRS_V_SPK.txt \
    device/htc/glacier/dsp/soundimage/Sound_Treble_Booster.txt:system/etc/soundimage/Sound_Treble_Booster.txt \
    device/htc/glacier/dsp/soundimage/Sound_Vocal_Booster.txt:system/etc/soundimage/Sound_Vocal_Booster.txt

# Additional NAM Audio DSP Profiles to NAM Package
PRODUCT_COPY_FILES += \
    device/htc/glacier/nam/default.acdb:system/etc/nam/default.acdb \
    device/htc/glacier/nam/default_org.acdb:system/etc/nam/default_org.acdb \
    device/htc/glacier/nam/AdieHWCodec.csv:system/etc/nam/AdieHWCodec.csv \
    device/htc/glacier/nam/AIC3254_REG_DualMic_MCLK.csv:system/etc/nam/AIC3254_REG_DualMic_MCLK.csv \
    device/htc/glacier/nam/CodecDSPID_MCLK.txt:system/etc/nam/CodecDSPID_MCLK.txt \
    device/htc/glacier/nam/Sound_Treble_Booster_MCLK.txt:system/etc/nam/Sound_Treble_Booster_MCLK.txt \
    device/htc/glacier/nam/Sound_Vocal_Booster_MCLK.txt:system/etc/nam/Sound_Vocal_Booster_MCLK.txt \
    device/htc/glacier/nam/Sound_SRS_A_SPK_MCLK.txt:system/etc/nam/Sound_SRS_A_SPK_MCLK.txt \
    device/htc/glacier/nam/Sound_SRS_V_HP_MCLK.txt:system/etc/nam/Sound_SRS_V_HP_MCLK.txt \
    device/htc/glacier/nam/Sound_SRS_V_SPK_MCLK.txt:system/etc/nam/Sound_SRS_V_SPK_MCLK.txt \
    device/htc/glacier/nam/Sound_Jazz_MCLK.txt:system/etc/nam/Sound_Jazz_MCLK.txt \
    device/htc/glacier/nam/Sound_Latin_MCLK.txt:system/etc/nam/Sound_Latin_MCLK.txt \
    device/htc/glacier/nam/Sound_New_Age_MCLK.txt:system/etc/nam/Sound_New_Age_MCLK.txt \
    device/htc/glacier/nam/Sound_Original_MCLK.txt:system/etc/nam/Sound_Original_MCLK.txt \
    device/htc/glacier/nam/Sound_Piano_MCLK.txt:system/etc/nam/Sound_Piano_MCLK.txt \
    device/htc/glacier/nam/Sound_Pop_MCLK.txt:system/etc/nam/Sound_Pop_MCLK.txt \
    device/htc/glacier/nam/Sound_R_B_MCLK.txt:system/etc/nam/Sound_R_B_MCLK.txt \
    device/htc/glacier/nam/Sound_Rock_MCLK.txt:system/etc/nam/Sound_Rock_MCLK.txt \
    device/htc/glacier/nam/Sound_SRS_A_HP_MCLK.txt:system/etc/nam/Sound_SRS_A_HP_MCLK.txt \
    device/htc/glacier/nam/Sound_Dualmic_SPK_MCLK.txt:system/etc/nam/Sound_Dualmic_SPK_MCLK.txt \
    device/htc/glacier/nam/Sound_Dualmic_EP_MCLK.txt:system/etc/nam/Sound_Dualmic_EP_MCLK.txt \
    device/htc/glacier/nam/Sound_Dualmic_MCLK.txt:system/etc/nam/Sound_Dualmic_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_A_SPK_MCLK.txt:system/etc/nam/Sound_Dolby_A_SPK_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_HP_MCLK.txt:system/etc/nam/Sound_Dolby_HP_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_Spk_MCLK.txt:system/etc/nam/Sound_Dolby_Spk_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_V_HP_MCLK.txt:system/etc/nam/Sound_Dolby_V_HP_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_V_SPK_MCLK.txt:system/etc/nam/Sound_Dolby_V_SPK_MCLK.txt \
    device/htc/glacier/nam/Sound_Dolby_A_HP_MCLK.txt:system/etc/nam/Sound_Dolby_A_HP_MCLK.txt \
    device/htc/glacier/nam/Sound_Bass_Booster_MCLK.txt:system/etc/nam/Sound_Bass_Booster_MCLK.txt \
    device/htc/glacier/nam/Sound_Blues_MCLK.txt:system/etc/nam/Sound_Blues_MCLK.txt \
    device/htc/glacier/nam/Sound_Classical_MCLK.txt:system/etc/nam/Sound_Classical_MCLK.txt \
    device/htc/glacier/nam/Sound_Country_MCLK.txt:system/etc/nam/Sound_Country_MCLK.txt

# Alternate NAM gps.conf to NAM package
PRODUCT_COPY_FILES += device/common/gps/gps.conf_US:system/etc/nam/gps.conf

PRODUCT_COPY_FILES += \
    device/htc/glacier/vold.fstab:system/etc/vold.fstab

# Additional older camera hacks
# PRODUCT_COPY_FILES += \
#    device/htc/glacier/prebuilt/app/CamFix.apk:system/app/CamFix.apk \
#    device/htc/glacier/prebuilt/app/FFCFix.apk:system/app/FFCFix.apk

# media config xml files
PRODUCT_COPY_FILES += \
    device/htc/glacier/media_codecs.xml:system/etc/media_codecs.xml \
    device/htc/glacier/media_profiles.xml:system/etc/media_profiles.xml

# bluetooth config file
PRODUCT_COPY_FILES += \
    device/htc/glacier/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

# Kernel modules
#PRODUCT_COPY_FILES += \

# stuff common to all HTC phones
$(call inherit-product, device/htc/common/common.mk)

# common msm7x30 configs
$(call inherit-product, device/htc/msm7x30-common/msm7x30.mk)

# htc audio settings
$(call inherit-product, device/htc/glacier/media_htcaudio.mk)
$(call inherit-product, device/htc/glacier/media_a1026.mk)

$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)


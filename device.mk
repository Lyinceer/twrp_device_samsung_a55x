#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/samsung/a55x

# Enable virtual A/B OTA
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    vendor_dlkm \
    dtbo \
    vendor_boot \
    system_dlkm \
    vendor \
    init_boot \
    vbmeta \
    odm \
    system \
    vbmeta_system \
    boot \
    product

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd 

PRODUCT_PACKAGES += \
    bootctrl.erd8845

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Shipping level
PRODUCT_SHIPPING_API_LEVEL := 32

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
	
# Vendor
PRODUCT_PACKAGES += \
    mkshrc_vendor \
    toybox_vendor \
    sh_vendor
	
# Vendor Boot Platform
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/platform/fstab.s5e8845:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.s5e8845 \
    $(LOCAL_PATH)/prebuilt/platform/fstab.s5e8845:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.s5e8845 \
    $(LOCAL_PATH)/prebuilt/platform/vangogh_lite_unified_evt0.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/lib/firmware/sgpu/vangogh_lite_unified_evt0.bin \
    $(LOCAL_PATH)/prebuilt/platform/vangogh_lite_unified_evt0.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/firmware/sgpu/vangogh_lite_unified_evt0.bin \
    $(LOCAL_PATH)/prebuilt/platform/gt9895_a55x.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/tsp/gt9895_a55x.bin
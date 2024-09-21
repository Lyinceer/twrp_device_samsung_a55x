#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/samsung/a55x

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    system \
    vendor \
    product \
    boot \
    vbmeta_vendor \
    vbmeta_system

PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=bin/checkpoint_gc \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd 

PRODUCT_PACKAGES += \
    fstab.s5e8845

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload \
    checkpoint_gc

# Rootdir
PRODUCT_PACKAGES += \
    gps.sh \
    enable_test_mode.sh \
    hdm_status.sh \
    init.insmod.sh \
    mx_log_collection.sh \
    mx_logger.sh \
    mx_logger_dump.sh \

# Vendor
PRODUCT_PACKAGES += \
    mkshrc_vendor \
    toybox_vendor \
    sh_vendor

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Shipping level
PRODUCT_SHIPPING_API_LEVEL := 32
PRODUCT_TARGET_VNDK_VERSION := 32

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
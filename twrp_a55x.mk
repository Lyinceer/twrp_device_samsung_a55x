#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/a55x

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# The app "/system/bin/bootctl" doesn't currently exist in custom recoveries, so running it currently does nothing. So we added this.
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/bootctl

# Inherit some common twrp stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from a55x device
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Product Name
PRODUCT_RELEASE_NAME := a55x
PRODUCT_DEVICE := $(PRODUCT_RELEASE_NAME)
PRODUCT_NAME := twrp_$(PRODUCT_RELEASE_NAME)
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A556E
PRODUCT_MANUFACTURER := samsung
PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

# Assert
TARGET_OTA_ASSERT_DEVICE := a55x

PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
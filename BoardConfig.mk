#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/a55x

# Allow for building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# AVB
BOARD_AVB_ENABLE := true

# Bootloader
BOARD_VENDOR := samsung
TARGET_SOC := s5e8845
TARGET_BOOTLOADER_BOARD_NAME := s5e8845
TARGET_NO_RADIOIMAGE := true
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI     := true

# Board
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_HAS_LARGE_FILESYSTEM := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := s5e8845
TARGET_NO_RADIOIMAGE := true
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Build Broken
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_PREPARE_DATA_MEDIA_EARLY := true
TW_SKIP_ADDITIONAL_FSTAB := true # Let recovery.fstab define in the tree be only source for fstab.
TW_FORCE_KEYMASTER_VER := true # Note that this is just a dummy value, because stock don't actually have keymaster, only keymint.

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

# Debug - Modules
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd

# Display
TARGET_SCREEN_DENSITY := 390
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

# DTBs
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb

# Kernel - Image
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_USES_GENERIC_KERNEL_IMAGE := true

# Kernel
TARGET_NO_KERNEL := true
BOARD_BOOT_HEADER_VERSION := 4
BOARD_DTB_OFFSET := 0x01f00000
BOARD_HEADER_SIZE := 2128
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE:= 2048
BOARD_RAMDISK_OFFSET := 0x00000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000000
BOARD_KERNEL_CMDLINE := bootconfig loop.max_part=7
TARGET_IS_64_BIT := true

# Mkbootimg
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

TARGET_BOARD_SUFFIX := _64                    # Remove if the device is 32-bit
TARGET_USES_64_BIT_BINDER := true             # Remove if the device is 32-bit

# Source
TARGET_KERNEL_CONFIG := a55x_defconfig
TARGET_KERNEL_SOURCE := kernel/samsung/a55x

# Partitions - Blocks
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

# Partition - Metadata
BOARD_USES_METADATA_PARTITION := true

# Partitions - Sizes
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTB_SIZE := 258920
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 16777216
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

BOARD_HAS_LARGE_FILESYSTEM := true

# Partition Type
BOARD_SYSTEMIMAGE_PARTITION_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs

# Partitions - Super/Logical
BOARD_SUPER_PARTITION_SIZE := 9539794832 # TODO: Fix hardcoded value
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor vendor_dlkm product odm
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 9539794832 # TODO: Fix hardcoded value

# GSI && GKI
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# Separate vendor_dlkm partition
BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

# Platform
TARGET_BOARD_PLATFORM := erd8845

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_INITRC := $(DEVICE_PATH)/recovery/root/init.recovery.s5e8845.rc

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS            := true

# Recovery
TARGET_NO_RECOVERY := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

# Ramdisk
BOARD_RAMDISK_USE_LZ4 := true

# SPL
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16.1.0

# TWRP Configuration
TW_THEME := portrait_hdpi
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_USE_TOOLBOX := true
TW_HAS_DOWNLOAD_MODE := true
TW_MAX_BRIGHTNESS := 200
TW_NO_LEGACY_PROPS := true
TW_NO_REBOOT_BOOTLOADER := true

# TWRP Configuration - Version
TW_DEFAULT_DEVICE_NAME := SM_A556E
TW_DEVICE_VERSION := SM_A556E - Lyinceer

# TWRP Configuration - Excludes
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_TWRPAPP := true

# TWRP Configuration - Includes
TW_INCLUDE_PYTHON := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_NTFS_3G := true

# TWRP Configuration - Vendor Modules
TW_LOAD_VENDOR_BOOT_MODULES := true

# Workaround for copyout error
TARGET_COPY_OUT_VENDOR := vendor
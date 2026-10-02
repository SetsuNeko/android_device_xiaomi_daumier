#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Xiaomi 12 Pro Dimensity (daumier) 产品定义
#
# 版本依据（实测原厂 OS2.0.6.0.ULGCNXM）：
#   system / system_ext / product  -> Android 14 (API 34)，通用 "missi"
#   vendor / odm / vendor_dlkm / odm_dlkm -> Android 12 (API 31)，daumier 专属
#
# 因此本机属于「旧 vendor + 新 system」组合，
# PRODUCT_SHIPPING_API_LEVEL 必须按 vendor 的 31 来定。
#

# 64 位 + 32 位兼容（abilist 含 armeabi-v7a）
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# 设备配置
$(call inherit-product, device/xiaomi/daumier/device.mk)

# 厂商 blob
$(call inherit-product, vendor/xiaomi/daumier/daumier-vendor.mk)

# 产品标识
PRODUCT_NAME := lineage_daumier
PRODUCT_DEVICE := daumier
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := 2207122MC

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# 说明：这里**不需要** PRODUCT_BUILD_PROP_OVERRIDES。
#
#   PRODUCT_DEVICE := daumier 已经会让 ro.product.device = daumier，
#   与原厂 vendor 的 ro.product.vendor.device=daumier 一致。
#
#   而 PRODUCT_NAME 保持 lineage_daumier（→ ro.product.name=lineage_daumier）
#   是 LineageOS 的规范做法。若把它覆盖成 daumier，会偏离规范且影响 OTA 识别。
#
# 原厂的产品标识（实测 odm/etc/build.prop，注意是 ro.product.odm.* 前缀；
# vendor/etc/build.prop 里**没有**任何 ro.product.* 属性）：
#   ro.product.odm.brand=Xiaomi
#   ro.product.odm.device=daumier
#   ro.product.odm.name=daumier
#   ro.product.odm.model=2207122MC
#   ro.product.odm.manufacturer=Xiaomi
#   ro.product.odm.marketname=Xiaomi 12 Pro Dimensity
#   ro.product.odm.cert=2207122MC
# 这些由 blob 提供，无需设备树干预。

# 关键：vendor 是 API 31（Android 12），system 是 API 34（Android 14）。
# 这个值必须等于 vendor 的 ro.board.api_level，否则 VINTF 校验会失败。
PRODUCT_SHIPPING_API_LEVEL := 31

# 设备指纹（原厂）
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.marketname=Xiaomi 12 Pro Dimensity

# 屏幕
PRODUCT_CHARACTERISTICS := nosdcard

# A/B + 虚拟 A/B
AB_OTA_UPDATER := true
#
# 注意：这里只列 AOSP 认识的分区。
# mi_ext 是小米私有分区，AOSP 构建系统没有对应的构建规则，故不列入。
#
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm \
    odm \
    odm_dlkm

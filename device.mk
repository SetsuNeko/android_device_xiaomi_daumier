#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# daumier 设备配置
#
# ⚠ 重要原则：
#   本设备树的 vendor / odm / vendor_dlkm / odm_dlkm 全部来自**预编译 blob**，
#   由 vendor/xiaomi/daumier 仓库（extract-files.py 生成）负责安装。
#   那些 HAL 服务的模块名由 blob 仓库定义，**不要**在这里重复列出，
#   否则会因找不到模块而编译失败。
#
#   这里只列**本设备树用源码构建**的东西。
#

DEVICE_PATH := device/xiaomi/daumier

# ============================================================================
# 属性
# ----------------------------------------------------------------------------
# TARGET_SYSTEM_PROP 在 BoardConfig.mk 里设置（指向 system.prop），
# 这里不重复设置，否则同一个文件会被加两次。
# ============================================================================

# ============================================================================
# 本设备树源码构建的模块
# ----------------------------------------------------------------------------
# bootctrl         —— MTK UFS 开机控制 HAL（源码在 bootctrl/）
# mtk_plpath_utils —— MTK preloader 设备映射工具（源码在 mtk_plpath_utils/）
# libinit_daumier  —— 属性覆盖静态库（源码在 init/）
#
# .recovery 变体由 Soong 为带 recovery_available: true 的模块自动生成，
# 用于 recovery 环境。接法参照 TWRP 参考树（已验证可用）。
# ============================================================================
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery \
    mtk_plpath_utils \
    mtk_plpath_utils.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# init 扩展库的接入方式
TARGET_INIT_VENDOR_LIB := libinit_daumier
TARGET_RECOVERY_DEVICE_MODULES := libinit_daumier

# ============================================================================
# Soong namespaces
# ----------------------------------------------------------------------------
#   $(LOCAL_PATH)：本设备树自带 Soong 模块（bootctrl/、mtk_plpath_utils/、
#     init/），注册后其对产品可见，否则 PRODUCT_PACKAGES 报 non-existent；
#   hardware/mediatek（mtkpower/mtkperf 等 HIDL 接口源码）与
#   hardware/xiaomi（displayfeature/touchfeature 等）是 blob 的依赖来源，
#   不注册会报 depends on undefined module。
#   与 dash 树 device.mk 同款写法。
# ============================================================================
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/mediatek \
    hardware/mediatek/libaedv \
    hardware/mediatek/libmtkperf_client \
    hardware/xiaomi

# ============================================================================
# A/B OTA 后处理
# ----------------------------------------------------------------------------
# mtk_plpath_utils 需要在 OTA 后运行，重建 preloader 的 device-mapper 节点。
# 来源：TWRP 参考树 device.mk（实测可用）
# ============================================================================
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/mtk_plpath_utils \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# ============================================================================
# 配置文件
# ----------------------------------------------------------------------------
# fstab：基于原厂 vendor/etc/fstab.mt6983 实测内容改写（见文件内注释）
#
# 这一个文件同时承担两个角色，这是 LineageOS 的标准做法：
#   1. PRODUCT_COPY_FILES  -> /vendor/etc/fstab.mt6983（运行时 init 用）
#   2. TARGET_RECOVERY_FSTAB -> recovery ramdisk 的 recovery.fstab
#
# 早先设备树里还有一份 recovery/root/system/etc/recovery.fstab，但它的目标
# 路径和 TARGET_RECOVERY_FSTAB 完全重合，两个来源写同一个文件是隐性冲突，
# 已经删除。
# ============================================================================
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6983:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6983

# ============================================================================
# vendor_boot ramdisk
# ----------------------------------------------------------------------------
# 原厂 vendor_boot 的 ramdisk 共 879 个普通文件 + 210 个符号链接（88 MB），
# 但其中 673 个文件是 AOSP recovery 的通用组件，LineageOS 会自己构建并
# 通过 BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT 合并进 vendor_boot。
# 复制它们会让两条规则抢同一个目标文件而编译失败，因此只保留设备独有的：
#
#   lib/modules/         200 个 —— 195 个 MTK 内核模块 + 5 个索引文件
#   first_stage_ramdisk/   2 个 —— fstab.mt6983 / fstab.emmc
#   init.recovery.*.rc     2 个 —— recovery 的硬件 init 脚本
#   prop.default           1 个 —— 原厂属性
#   system/etc/init/mtk-plpath-utils.rc  1 个 —— plpath 服务定义
#
# 符号链接只还原 19 个「指向路径」的挂载点（bin/etc/init/odm/*/...）。
# 另外 191 个指向 AOSP 可执行文件的 applet 链接（date -> toybox 之类）
# **不还原**：原厂那份是 Android 12 时代的，而现代 AOSP 已移除 toolbox、
# ziptool，照抄会产生悬空链接；且目标文件由 AOSP 构建产出，会抢路径。
#
# 文件清单在 prebuilt/vendor_ramdisk_files.mk（206 条 PRODUCT_COPY_FILES）
# 符号链接由 prebuilt/Android.mk 的 post-install 步骤还原（19 条）
# ============================================================================
include $(DEVICE_PATH)/prebuilt/vendor_ramdisk_files.mk

PRODUCT_PACKAGES += \
    vendor_ramdisk_symlinks

# ============================================================================
# VINTF
# ----------------------------------------------------------------------------
# 说明：vendor 的 device manifest 和 compatibility matrix **随 blob 提供**，
#       位于 vendor/etc/vintf/。因此这里**不设置** DEVICE_MANIFEST_FILE，
#       否则会覆盖掉原厂那份，导致大量 HAL 声明丢失。
#
#       原厂 vendor manifest 关键信息（实测）：
#         <manifest version="4.0" type="device" target-level="6">
#         <sepolicy><version>31.0</version></sepolicy>
#         <kernel target-level="6"/>
#
#       需要补充 HAL 声明时，用 PRODUCT_COPY_FILES 往
#       vendor/etc/vintf/manifest/ 里**追加**文件（该目录会与原厂
#       manifest.xml 合并），不要用 DEVICE_MANIFEST_FILE 覆盖。
#
#       三种 VINTF 变量的分工见 configs/vintf/compatibility_matrix.xml 顶部注释。
# ============================================================================

# 设备 manifest 追加（不覆盖原厂）
# 2026-10-05：AOSP 新版禁止用 PRODUCT_COPY_FILES 装 VINTF 元数据
# （build/make/core/Makefile:148 检查），改用专用变量 DEVICE_MANIFEST_FILES
# （可多文件、合并进 vendor manifest，不覆盖原厂那份）。
DEVICE_MANIFEST_FILES += \
    $(DEVICE_PATH)/rootdir/etc/vintf/manifest/lineage_daumier.xml

# ODM VINTF SKU manifest 片段（radio HAL 的 4 个卡型变体）
# AOSP 的 ODM_MANIFEST_SKUS + ODM_MANIFEST_<SKU>_FILES 机制自带
# assemble_vintf 合并并安装成 odm/etc/vintf/manifest_<sku>.xml
# （build/make/target/board/android-info.mk:117），源文件直接指到
# vendor 树里提取出的原厂文件。
ODM_MANIFEST_SKUS := dsds qsqs ss tsts
ODM_MANIFEST_FILES := \
    vendor/xiaomi/daumier/proprietary/odm/etc/vintf/manifest_dsds.xml
ODM_MANIFEST_DSDS_FILES := \
    vendor/xiaomi/daumier/proprietary/odm/etc/vintf/manifest_dsds.xml
ODM_MANIFEST_QSQS_FILES := \
    vendor/xiaomi/daumier/proprietary/odm/etc/vintf/manifest_qsqs.xml
ODM_MANIFEST_SS_FILES := \
    vendor/xiaomi/daumier/proprietary/odm/etc/vintf/manifest_ss.xml
ODM_MANIFEST_TSTS_FILES := \
    vendor/xiaomi/daumier/proprietary/odm/etc/vintf/manifest_tsts.xml

# 框架兼容性矩阵片段：声明本设备树新增的 boot HAL，并归档原厂 vendor 的 HAL 清单
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml

# ============================================================================
# 属性
# ----------------------------------------------------------------------------
# ⚠ 这里**刻意不设置 PRODUCT_VENDOR_PROPERTIES**，原因有两个：
#
#   1. **会与 blob 抢文件。** 预编译的 vendor blob 里已经有一份
#      vendor/build.prop（extract-files.py 会把它拷到 vendor 分区）。
#      PRODUCT_VENDOR_PROPERTIES 同样是往 vendor/build.prop 里写内容，
#      两者会冲突。
#
#   2. **内容完全重复。** 原厂 vendor/build.prop 和 prop.default 里已经有
#      这些属性，设备上本来就会生效。
#
#   设备相关的属性统一放在 system.prop（-> /system/build.prop），
#   那里每一条都逐字核对过原厂值并标注了来源。
# ============================================================================

# ============================================================================
# 屏幕
# ============================================================================
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

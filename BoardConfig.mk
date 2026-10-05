#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Xiaomi 12 Pro Dimensity (daumier) / MT6983
#
# 本文件中的所有数值均来自原厂镜像 OS2.0.6.0.ULGCNXM 实测，
# 不是猜的。数据来源标注在每个小节。
#

DEVICE_PATH := device/xiaomi/daumier

# ============================================================================
# 架构
# ----------------------------------------------------------------------------
# 来源：vendor/build.prop -> ro.bionic.cpu_variant=cortex-a55
#       dalvik.vm.isa.arm64.variant=cortex-a55
#       ro.product.cpu.abilist=arm64-v8a,armeabi-v7a,armeabi
#
# MT6983 实际核心是 1x Cortex-X2 + 3x Cortex-A710 + 4x Cortex-A510（ARMv9-A），
# 但原厂 bionic 基线用的是 cortex-a55（ARMv8.2-A）。这里跟随原厂，
# 保证二进制兼容性优先。
# ============================================================================
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# （TARGET_USES_64_BIT_BINDER 已废弃，AOSP 现在默认全部 64 位 binder，不再设置）
TARGET_SUPPORTS_64_BIT_APPS := true

# ============================================================================
# 平台
# ----------------------------------------------------------------------------
# 来源：vendor/build.prop -> ro.board.platform=mt6983 / ro.soc.model=MT6983
# ============================================================================
TARGET_BOARD_PLATFORM := mt6983
TARGET_BOOTLOADER_BOARD_NAME := mt6983

TARGET_NO_BOOTLOADER := true

# ============================================================================
# 镜像分区目录（TARGET_COPY_OUT_*）
# ----------------------------------------------------------------------------
# 本树是 A/B + 动态分区 + 独立 vendor/odm/product/system_ext/vendor_dlkm/
# odm_dlkm 镜像（下方 BOARD_*IMAGE_FILE_SYSTEM_TYPE），这些目录必须显式
# 指到分区根，否则保留 envsetup 里的 _placeholder（system/vendor 等），
# 与镜像类型声明互相矛盾 → board_config.mk:705 直接 error 挡掉 lunch。
# 值与 dash 树一致。
# ============================================================================
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_ODM_DLKM := odm_dlkm
TARGET_COPY_OUT_PRODUCT := product
# 不设 TARGET_COPY_OUT_SYSTEM_DLKM：本机 super 里没有 system_dlkm 分区
# （stock 的 main 组只有 system/system_ext/product/vendor/odm/vendor_dlkm/
# odm_dlkm/mi_ext）。设成 'system_dlkm' 会触发 board_config.mk:919 要求
# BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE，而本机根本不构建该镜像。
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

# 内核：使用预编译的 Google GKI 内核，不编译内核源码
#   实测版本 5.10.226-android12-9-00047-g4968e29b7f92-ab12786767
#   提取自 OS2.0.6.0 的 boot.img，md5 = 42a6ae2569bf576cc09f9b6c20509795
#   gzip 压缩（19630219 字节），与 boot.img 头部的 kernel_size 完全一致
#
# ⚠ TWRP 参考树里写的是 TARGET_NO_KERNEL := true —— 那是因为 TWRP 不往
#   镜像里放内核。LineageOS 需要内核，因此改用 TARGET_PREBUILT_KERNEL。
#   这两个变量互斥，不能同时设置。
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_KERNEL_IMAGE_NAME := Image.gz

# 本机没有 recovery 分区（见 MT6983_Android_scatter.txt），
# recovery 资源通过 BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT 打进 vendor_boot
TARGET_NO_RECOVERY := true

# ============================================================================
# 引导头参数
# ----------------------------------------------------------------------------
# 来源：实测 vendor_boot.img / boot.img 头部（MTK boot header v4）
# 已与 TWRP 参考树交叉验证一致。
# ============================================================================
BOARD_KERNEL_BASE := 0x3fff8000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x26f08000
BOARD_TAGS_OFFSET := 0x07c88000
BOARD_DTB_OFFSET := 0x07c88000

BOARD_BOOT_HEADER_VERSION := 4
BOARD_HEADER_SIZE := 2128
BOARD_PAGE_SIZE := 4096
BOARD_FLASH_BLOCK_SIZE := 262144

# 来源：vendor_boot.img -> cmdline
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2

# GKI 通用内核镜像 + recovery 资源进 vendor_boot
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

# ---- DTB ----
# 实测：DTB 在 vendor_boot 里，不在 boot 里。
#   boot.img        -> header v4, header_size 1584, 只有 kernel + ramdisk
#   vendor_boot.img -> header v4, header_size 2128, dtb_size = 335112
#
# 因此**不设** BOARD_INCLUDE_DTB_IN_BOOTIMG（那是给非 GKI 的 boot.img 用的）。
# AOSP 期望预编译 DTB 的文件名是 dtb.img。
#
# prebuilt/dtb.img 提取自 OS2.0.6.0 的 vendor_boot.img
#   md5 = e61a55917fca5b33eb28888c534f4248
# （TWRP 参考树里那份 815cd375ad7434a1bf67b06911e782dd 是 MIUI 14 时期的，已弃用）
# BOARD_INCLUDE_DTB_IN_BOOTIMG：AOSP 要求设置 BOARD_PREBUILT_DTBIMAGE_DIR 时
# 必须为 true（board_config.mk:1006）。GKI 模式下它实际生效的位置是
# vendor_boot（本机 DTB 实测就在 vendor_boot 里，与原厂一致）。
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt

# ============================================================================
# 分区尺寸
# ----------------------------------------------------------------------------
# 来源：MT6983_Android_scatter.txt (UFS_LU2) + super.img 的 LP metadata
# 注意：本机是 UFS（scatter 里 EMMC_* 那套是同一个 scatter 的兼容布局，不适用）
# ============================================================================
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864          # 64 MiB
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864   # 64 MiB
BOARD_DTBOIMG_PARTITION_SIZE := 33554432            # 32 MiB

# 动态分区（super）
BOARD_SUPER_PARTITION_SIZE := 9126805504            # 8704 MiB
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 9116319744
#
# 注意：原厂的 main 组里有 8 个分区，但 AOSP 构建系统只认识其中 7 个。
#   mi_ext 是小米私有的"扩展"分区（原厂仅 144 KiB），存放叠加到
#   system/product 上的 overlay 文件，LineageOS 完全用不到。
#   AOSP 没有 BOARD_MI_EXTIMAGE_* 这套变量，直接写进去会导致编译失败。
#
# 因此这里只列 7 个。super 会小 144 KiB，对功能无影响。
# 若日后确实需要 mi_ext，需自行补一套自定义分区构建规则。
#
BOARD_MAIN_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    odm \
    vendor_dlkm \
    odm_dlkm
#    mi_ext        # ← 需要时再启用，并补上对应的构建规则

# 物理分区
BOARD_USES_METADATA_PARTITION := true
BOARD_METADATAIMAGE_PARTITION_SIZE := 33554432      # 32 MiB
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12884901888   # 12288 MiB
BOARD_CACHEIMAGE_PARTITION_SIZE := 134217728        # 128 MiB（scatter 里叫 rescue）
BOARD_PERSISTIMAGE_PARTITION_SIZE := 67108864       # 64 MiB
BOARD_NVCFGIMAGE_PARTITION_SIZE := 33554432         # 32 MiB
BOARD_NVDATAIMAGE_PARTITION_SIZE := 67108864        # 64 MiB
BOARD_PROTECT1IMAGE_PARTITION_SIZE := 8388608       # 8 MiB
BOARD_PROTECT2IMAGE_PARTITION_SIZE := 8388608       # 8 MiB

# ============================================================================
# 文件系统
# ----------------------------------------------------------------------------
# 来源：vendor/etc/fstab.mt6983
# 所有逻辑分区都是 EROFS；userdata 是 f2fs；metadata/persist 等是 ext4
# ============================================================================
TARGET_USES_EROFS := true

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_MI_EXTIMAGE_FILE_SYSTEM_TYPE := erofs

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_METADATAIMAGE_FILE_SYSTEM_TYPE := ext4

# EROFS 压缩：原厂用 lz4（由 mkfs.erofs 的 -zlz4 控制）
BOARD_EROFS_COMPRESSOR := lz4

# ============================================================================
# AVB 2.0
# ----------------------------------------------------------------------------
# 来源：实测 vbmeta.img / vbmeta_system.img / vbmeta_vendor.img
#
# 原厂链结构：
#   vbmeta.img
#     ├── CHAIN boot            (rollback_index_location=3)
#     ├── CHAIN vbmeta_system   (2)  -> system, system_ext, product
#     ├── CHAIN vbmeta_vendor   (4)  -> vendor
#     ├── HASH    vendor_boot
#     └── HASHTREE mi_ext, odm, odm_dlkm, vendor_dlkm
#
# 算法：SHA256_RSA2048（libavb 1.0，avbtool 1.2.0）
# 注意：下面用 AOSP 的测试密钥，正式发布请换成自己的密钥。
# ============================================================================
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem

BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 2
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := 4
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 4

BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ROLLBACK_INDEX := 3
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3

# ============================================================================
# 内核模块
# ----------------------------------------------------------------------------
# 来源：实测
#   vendor_boot 的 ramdisk   -> lib/modules/  195 个 .ko（第一阶段）
#   vendor_dlkm 分区         -> lib/modules/  225 个 .ko（第二阶段）
#   两边有 25 个重名
#
# 内核：5.10.226-android12-9（GKI，android12-5.10 分支）
# 模块 vermagic：5.10.226-android12-9-gac0ac333ab3c
#
# ⚠ 这里**刻意不设置** BOARD_VENDOR_RAMDISK_KERNEL_MODULES 与
#   BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD。
#
#   那套机制会让构建系统自己往 vendor ramdisk 的 lib/modules/ 里塞模块并
#   生成 modules.load。但本设备树是把原厂整个 lib/modules/ 目录（195 个 .ko
#   + modules.load / modules.load.recovery / modules.dep / modules.alias /
#   modules.softdep）通过 PRODUCT_COPY_FILES 原样搬进去的，目标路径完全重合。
#   两套机制同时开着会互相抢文件，而且生成出来的 modules.load 顺序未必和
#   原厂一致 —— MTK 的模块加载顺序有依赖，必须沿用原厂那份。
#
#   原厂 modules.load 174 行、modules.load.recovery 191 行，都在
#   prebuilt/vendor_ramdisk/lib/modules/ 里。
# ============================================================================

# ============================================================================
# Recovery
# ----------------------------------------------------------------------------
# 来源：vendor/build.prop -> ro.minui.pixel_format=BGRA_8888
# ============================================================================
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6983
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 90

# ============================================================================
# 显示
# ----------------------------------------------------------------------------
# 来源：vendor/build.prop -> ro.sf.lcd_density=480
#       persist.sys.miui_resolution=1080,2400,420
#       面板原生 1440x3200，系统默认跑 1080x2400
# ============================================================================
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_DENSITY := 480

# ============================================================================
# SELinux
# ----------------------------------------------------------------------------
# 原厂策略随 blob 提供（vendor 分区）：
#   vendor/etc/selinux/vendor_sepolicy.cil        (1.1 MB)
#   vendor/etc/selinux/plat_pub_versioned.cil     (930 KB)
#   vendor/etc/selinux/plat_sepolicy_vers.txt     -> "31.0"
#   odm/etc/selinux/precompiled_sepolicy          (1.3 MB)
#
# 设备树只补**原厂没覆盖、且 LineageOS 会替换掉**的那一小块：
#   mtk_plpath_utils 的类型定义 —— 原厂把它放在 system_ext 策略里，
#   而 system_ext 在 LineageOS 上是重新构建的，那层策略不复存在。
#
# 开机控制 HAL（bootctrl/）**不需要**任何补充策略：
#   原厂 vendor_file_contexts 第 18 行已用正则覆盖
#   /(vendor|system/vendor)/bin/hw/android\.hardware\.boot@1\.[0-9]+-service，
#   vendor_sepolicy.cil 里也已把 hal_bootctl_default 的权限授全
#   （实测含 sys_rawio、block_device、bootdevice_block_device 等）。
#   我们只是替换了 impl 动态库，运行域不变。
#
# ⚠ 原厂策略是按平台策略版本 31.0 编译的。LineageOS 23 的平台版本是 36.0，
#   两者差异由 plat_pub_versioned.cil 的版本化机制消化。若编译时 sepolicy
#   报版本不匹配，需要调整 BOARD_API_LEVEL 相关配置（见 README 风险清单）。
# ============================================================================
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# ============================================================================
# 其他
# ============================================================================
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# 虚拟 A/B 的 super 配置
# 注：BOARD_USES_METADATA_PARTITION 已在「分区尺寸」一节设置，此处不重复。
BOARD_SUPER_PARTITION_METADATA_DEVICE := super
BOARD_SUPER_PARTITION_BLOCK_DEVICES := super

# ============================================================================
# 继承 vendor 树生成的配置（提取器写出来的，勿手改）
# ----------------------------------------------------------------------------
# vendor/xiaomi/daumier/BoardConfigVendor.mk 由 extract-files.py 生成：
#   proprietary-firmware.txt 里带 ';AB' 的镜像会写进 AB_OTA_PARTITIONS。
# 本树原本漏了这一行 include（dash 树末尾有），导致提取器生成的
# AB_OTA_PARTITIONS 永远不生效 —— dtbo 靠 lineage_daumier.mk 里那份兜住了，
# 但以后往 proprietary-firmware.txt 加镜像（基带、tee 等）就会静默丢失。
# ============================================================================
include vendor/xiaomi/daumier/BoardConfigVendor.mk

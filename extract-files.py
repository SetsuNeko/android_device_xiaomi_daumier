#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# daumier 厂商 blob 提取入口
#
# 原版脚本调用 extract_utils.main.extract_utils_main()，但 LineageOS 的
# tools/extract-utils 所有分支（lineage-18.1 ~ 24.0）都还没有这个函数，
# 只有类式 API。这里改成与 dash 设备树一致的类式写法：
#   ExtractUtils.device(module).run()
# 输出固定为 vendor/<vendor>/<device> = vendor/xiaomi/daumier
#
# 用法：
#   ./extract-files.py <原厂镜像解包目录>
#   （目录下需有 vendor/ odm/ vendor_dlkm/ odm_dlkm/ product/ system/ system_ext/ 子目录，
#     以及 proprietary-firmware.txt 里列出的分区镜像 —— 提取器按 file.dst
#     在输入目录**根部**找它们，例如 <目录>/dtbo.img）
#
# 需要 sudo：EROFS 解出来的目录里有 root-only 文件，普通用户读会 permission denied。

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)

# 让生成的 vendor/xiaomi/daumier/Android.bp 里的 soong_namespace 导入这些目录，
# 否则 blob 的依赖解析不到它们的模块（实测报 depends on undefined module
# vendor.mediatek.hardware.mtkpower@1.x —— 这些 HIDL 接口源码在 hardware/mediatek，
# 不导入的话该命名空间对 blob 不可见）。清单照抄 dash。
# 注意：**不能**把 device/xiaomi/daumier 也放进来 —— 本设备树里没有 Android.bp，
# import 一个"不存在的命名空间"会直接报 namespace ... does not exist。
# 命名空间对产品的注册在 device.mk 的 PRODUCT_SOONG_NAMESPACES（同 dash）。
namespace_imports = [
    'hardware/mediatek',
    'hardware/mediatek/libaedv',
    'hardware/mediatek/libmtkperf_client',
    'hardware/xiaomi',
]

# A16 的 aidl_interface 已删除 ndk_platform 后端（只剩 -ndk）。原厂 blob 里
# 还带着对以下 **AOSP 有源码** 接口的 ndk_platform NEEDED，必须 replace_needed
# 改成 -ndk（否则 soong 报 depends on undefined module）：
#   android.hardware.power-V2 / android.hardware.gnss-V1 /
#   android.hardware.security.keymint-V1 / secureclock-V1 / sharedsecret-V1 /
#   android.system.keystore2-V1
# 注意 **不要**动 arm.graphics-V1 / vendor.xiaomi.hardware.mrm-V1：
# 它们 AOSP 无源码、由本 vendor 树的 blob 自己提供（清单里保留着），
# NEEDED 直接解析到我们自己的模块。
# A16 已删除 aidl 的 ndk_platform 后端（只剩 -ndk）。原厂 blob 里对 AOSP 有源码
# 接口的 ndk_platform NEEDED 由提取器统一改写；arm.graphics-V1 /
# vendor.xiaomi.hardware.mrm-V1 是 AOSP 无源码、本 vendor 树自供，不能改。
blob_fixups: blob_fixups_user_type = {
    (
        'vendor/bin/factory',
        'vendor/bin/hw/android.hardware.lights-service.mediatek',
    ): blob_fixup()
        .replace_needed('android.hardware.light-V1-ndk_platform.so', 'android.hardware.light-V1-ndk.so'),
    (
        'vendor/bin/hw/android.hardware.gnss-service.mediatek',
        'vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so'),
    'vendor/bin/hw/android.hardware.memtrack-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.memtrack-V1-ndk_platform.so', 'android.hardware.memtrack-V1-ndk.so'),
    (
        'vendor/bin/hw/android.hardware.security.keymint@1.0-service.beanpod',
        'vendor/lib64/libkeymint.so',
    ): blob_fixup()
        .replace_needed('android.hardware.security.keymint-V1-ndk_platform.so', 'android.hardware.security.keymint-V1-ndk.so')
        .replace_needed('android.hardware.security.secureclock-V1-ndk_platform.so', 'android.hardware.security.secureclock-V1-ndk.so')
        .replace_needed('android.hardware.security.sharedsecret-V1-ndk_platform.so', 'android.hardware.security.sharedsecret-V1-ndk.so'),
    'vendor/bin/hw/android.hardware.vibrator-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.vibrator-V2-ndk_platform.so', 'android.hardware.vibrator-V2-ndk.so'),
    (
        'vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service',
        'vendor/lib64/android.hardware.power-service-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.hardware.power-V2-ndk_platform.so', 'android.hardware.power-V2-ndk.so'),
    'vendor/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service': blob_fixup()
        .replace_needed('android.hardware.vibrator-V1-ndk_platform.so', 'android.hardware.vibrator-V1-ndk.so'),
        # 注意：同文件里 vendor.hardware.vibratorfeature.IVibratorExt-V1-ndk_platform
        # 是小米私有接口、AOSP 无源码，库由本 vendor 树提供（清单保留着），
        # NEEDED 不改 —— 上一轮误把它一起改成 -ndk 导致 undefined module。
    'vendor/lib64/lib_android_keymaster_keymint_utils.so': blob_fixup()
        .replace_needed('android.hardware.security.keymint-V1-ndk_platform.so', 'android.hardware.security.keymint-V1-ndk.so'),
    'vendor/lib64/libkeystore-engine-wifi-hidl.so': blob_fixup()
        .replace_needed('android.system.keystore2-V1-ndk_platform.so', 'android.system.keystore2-V1-ndk.so')
}  # fmt: skip

module = ExtractUtilsModule(
    'daumier',
    'xiaomi',
    # 处理 proprietary-firmware.txt：把分区镜像收进 radio/，
    # 并生成 Android.mk 的 add-radio-file-sha1-checked 与
    # BoardConfigVendor.mk 的 AB_OTA_PARTITIONS（dtbo 必须走这条路，
    # 否则 AB_OTA_PARTITIONS 里的 dtbo 找不到镜像，OTA 打包会失败）。
    add_firmware_proprietary_file=True,
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()

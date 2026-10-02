#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# daumier 厂商 blob 提取入口
#
# 用法（在设备树目录下执行）：
#
#   ./extract-files.py --only-files ../../xiaomi-images/ ../../vendor/xiaomi/daumier
#
# 参数说明：
#   --only-files   只提取 blob，不重新生成 Android.mk / *-vendor.mk
#                  （首次提取时**不要**加这个参数）
#   第一个路径     原厂镜像解包目录（需要 product/ system/ system_ext/
#                  vendor/ odm/ vendor_dlkm/ odm_dlkm/ 等子目录）
#   第二个路径     输出目录，通常是 vendor/xiaomi/daumier
#
# 真正的实现在 LineageOS 的 tools/extract-utils 仓库：
#   https://github.com/LineageOS/android_tools_extract-utils
# 编译前需要先 clone 到源码树的 tools/extract-utils：
#   git clone https://github.com/LineageOS/android_tools_extract-utils \
#       -b lineage-23.0 tools/extract-utils
#
# 本设备树的 proprietary-files.txt 说明：
#   条目的路径是**相对分区根**的，例如 vendor/lib64/libfoo.so 会被从
#   <镜像目录>/vendor/lib64/libfoo.so 提取到
#   vendor/xiaomi/daumier/proprietary/vendor/lib64/libfoo.so
#
#   system / system_ext / product 三个分区**不在**清单里，因为原厂那三个
#   分区是通用 missi 镜像（Android 14），不含 daumier 专属 blob。

from extract_utils.main import extract_utils_main

if __name__ == '__main__':
    extract_utils_main()

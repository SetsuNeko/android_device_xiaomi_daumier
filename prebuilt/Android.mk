#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# vendor_boot ramdisk 的符号链接还原
#
# ========================================================================
# 为什么需要这一步
# ========================================================================
#
# PRODUCT_COPY_FILES 只能复制普通文件，源头的符号链接会被解引用成真实文件
# （cp 默认跟随链接）。原厂 vendor_boot ramdisk 里有 210 个符号链接，其中
# 19 个是挂载点，必须显式重建。
#
# ========================================================================
# 为什么只还原 19 个，而不是全部 210 个
# ========================================================================
#
# 另外 191 个是指向 AOSP 可执行文件的 applet 链接，形如：
#     system/bin/date -> toybox
#     system/bin/getprop -> toolbox
#     system/bin/unzip -> ziptool
#
# 原厂 ramdisk 是 Android 12 时代的，而 LineageOS 23 的 recovery 由
# bootable/recovery 与 system/core/shell_and_utilities 重新构建，
# 会自带这些 applet 链接。**不能照抄**，原因有二：
#   1. 现代 AOSP 已经移除 toolbox、ziptool，照抄会产生悬空链接；
#   2. 目标文件（system/bin/toybox 等）由 AOSP 构建产出，
#      设备树复制的那份反而会和它抢同一个目标路径。
#
# 下面这 19 个链接的目标都是**路径**而不是二进制，重建它们是幂等的：
# 若 AOSP 已经建过，ln -sf 只是原样覆盖；若没有，就补上原厂行为。
#
# ========================================================================
# 关于 TARGET_VENDOR_RAMDISK_OUT
# ========================================================================
#
# 这个变量名**未经编译验证**（设备树作者手上没有源码树）。
# 它必须指向 vendor ramdisk 的根目录，否则下面的 ln 会写进错误的位置，
# 而且不会有任何报错。所以安装前先做一次断言：
# 检查 prop.default 是否已经在那里——它是本设备树通过
# PRODUCT_COPY_FILES 装进去的，能可靠地证明目录找对了。
#
# 如果编译时报 "vendor ramdisk 目录定位失败"，说明变量名在当前 AOSP
# 分支里已经改了。请到 build/make/core/ 里搜索 vendor_ramdisk，
# 找到真正的输出目录变量名，改下面那一行即可。
#
# 本文件由设备树作者生成，请勿手改。
#

LOCAL_PATH := $(call my-dir)

# 兜底定义。若 AOSP 未定义此变量，$(PRODUCT_OUT)/vendor_ramdisk 同样是
# PRODUCT_COPY_FILES 用 $(TARGET_COPY_OUT_VENDOR_RAMDISK) 落地的位置，两者一致。
TARGET_VENDOR_RAMDISK_OUT ?= $(PRODUCT_OUT)/vendor_ramdisk

include $(CLEAR_VARS)
LOCAL_MODULE := vendor_ramdisk_symlinks
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_VENDOR_RAMDISK_OUT)
LOCAL_MODULE_STEM := .symlinks.stamp
LOCAL_SRC_FILES := .symlinks.stamp
# 本地补丁（AviumUI 构建）：断言依赖的 prop.default 由 vendor_ramdisk_files.mk
# 的 PRODUCT_COPY_FILES 落地，但 ninja 对两者之间**没有顺序保证**（实测先跑
# stamp 后跑 copy → 断言误报）。显式补一条依赖边，让 copy 先完成。
LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_VENDOR_RAMDISK_OUT)/prop.default

LOCAL_POST_INSTALL_CMD := \
	if [ ! -f '$(TARGET_VENDOR_RAMDISK_OUT)/prop.default' ]; then \
	    echo "*** vendor ramdisk 目录定位失败 ***"; \
	    echo "    TARGET_VENDOR_RAMDISK_OUT = $(TARGET_VENDOR_RAMDISK_OUT)"; \
	    echo "    该目录下没有找到 prop.default，说明这不是 vendor ramdisk 的根目录。"; \
	    echo "    请核对 build/make/core/ 里 vendor ramdisk 的输出目录变量名，"; \
	    echo "    然后修改 device/xiaomi/daumier/prebuilt/Android.mk。"; \
	    exit 1; \
	fi; \
	ln -sf '/system/bin' '$(TARGET_VENDOR_RAMDISK_OUT)/bin'; \
	ln -sf '/data/user_de/0/com.android.shell/files/bugreports' '$(TARGET_VENDOR_RAMDISK_OUT)/bugreports'; \
	ln -sf '/sys/kernel/debug' '$(TARGET_VENDOR_RAMDISK_OUT)/d'; \
	ln -sf 'prop.default' '$(TARGET_VENDOR_RAMDISK_OUT)/default.prop'; \
	ln -sf '/system/etc' '$(TARGET_VENDOR_RAMDISK_OUT)/etc'; \
	ln -sf '/system/bin/init' '$(TARGET_VENDOR_RAMDISK_OUT)/init'; \
	ln -sf '/vendor/odm/app' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/app'; \
	ln -sf '/vendor/odm/bin' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/bin'; \
	ln -sf '/vendor/odm/etc' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/etc'; \
	ln -sf '/vendor/odm/firmware' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/firmware'; \
	ln -sf '/vendor/odm/framework' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/framework'; \
	ln -sf '/vendor/odm/lib' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/lib'; \
	ln -sf '/vendor/odm/lib64' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/lib64'; \
	ln -sf '/vendor/odm/overlay' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/overlay'; \
	ln -sf '/vendor/odm/priv-app' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/priv-app'; \
	ln -sf '/vendor/odm/usr' '$(TARGET_VENDOR_RAMDISK_OUT)/odm/usr'; \
	ln -sf '/odm/odm_dlkm/etc' '$(TARGET_VENDOR_RAMDISK_OUT)/odm_dlkm/etc'; \
	ln -sf '/system/system_ext' '$(TARGET_VENDOR_RAMDISK_OUT)/system_ext'; \
	ln -sf '/vendor/vendor_dlkm/etc' '$(TARGET_VENDOR_RAMDISK_OUT)/vendor_dlkm/etc'; \
	true
include $(BUILD_PREBUILT)

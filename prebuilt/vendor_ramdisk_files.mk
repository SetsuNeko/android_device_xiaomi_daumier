#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# vendor_boot ramdisk 的文件安装规则
#
# ════════════════════════════════════════════════════════════════════════
# 这里**只**放 LineageOS 不会自己生成、且设备独有的文件
# ════════════════════════════════════════════════════════════════════════
#
# 原厂 vendor_boot ramdisk 共 879 个普通文件 + 210 个符号链接。
# 其中 673 个文件是 AOSP recovery 的通用组件（res/ 界面资源、system/bin/
# 可执行文件、system/lib64/、system/etc/init/*.rc、first_stage_ramdisk/
# 的 e2fsck/linker64/snapuserd 等），LineageOS 会自己构建并合并进
# vendor_boot（见 BoardConfig.mk 的 BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT
# 与 BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT）。
# 复制它们会造成两条规则写同一个目标文件而编译失败，因此全部剔除。
#
# 保留的 206 个文件：
#   lib/modules/  200 个 —— MTK 内核模块，设备独有，recovery 挂载分区必需
#   其余           6 个 —— 设备 fstab、recovery init 脚本、原厂属性、plpath 服务定义
#
# 符号链接（19 个挂载点）由 prebuilt/Android.mk 还原。
#
# 本文件由设备树作者生成，请勿手改。
#

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/first_stage_ramdisk/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/first_stage_ramdisk/fstab.mt6983:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6983 \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/init.recovery.hardware.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.hardware.rc \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/init.recovery.mt6983.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.mt6983.rc \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/prop.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/prop.default \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/system/etc/init/mtk-plpath-utils.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system/etc/init/mtk-plpath-utils.rc \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/8250_mtk.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/8250_mtk.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/adapter_class.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/adapter_class.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/adsp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/adsp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/aee_aed.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/aee_aed.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/aee_hangdet.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/aee_hangdet.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/aee_rs.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/aee_rs.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/arm_dsu_pmu.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/arm_dsu_pmu.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/blocktag.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/blocktag.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/bootprof.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/bootprof.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/bq28z610.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/bq28z610.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/bus-parity.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/bus-parity.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/cache-parity.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/cache-parity.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/cfg80211.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/cfg80211.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/charger_class.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/charger_class.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-bringup.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-bringup.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-chk-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-chk-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-common.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-common.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-dbg-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-dbg-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-disable-unused.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-disable-unused.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-fmeter-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-fmeter-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-adsp_grp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-adsp_grp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-cam.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-cam.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-ccu_main.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-ccu_main.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-img.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-img.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-imp_iic_wrap.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-imp_iic_wrap.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-mdp_grp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-mdp_grp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-mm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-mm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983-vcodec.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983-vcodec.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clk-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clk-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/clkbuf.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/clkbuf.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/cmdq-platform-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/cmdq-platform-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/cmdq_helper_inf.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/cmdq_helper_inf.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/cqhci.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/cqhci.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/dbgtop-drm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/dbgtop-drm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/device-apc-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/device-apc-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/emi-mpu.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/emi-mpu.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/emi-slb.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/emi-slb.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/emi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/emi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/extcon-mtk-usb.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/extcon-mtk-usb.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/extdev_io_class.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/extdev_io_class.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/fan53870.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/fan53870.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/fts_touch_spi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/fts_touch_spi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/gpu_plaid.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/gpu_plaid.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/i2c-mt65xx.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/i2c-mt65xx.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/industrialio-triggered-buffer.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/industrialio-triggered-buffer.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/iommu_debug.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/iommu_debug.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/iommu_secure.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/iommu_secure.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/irq-dbg.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/irq-dbg.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/isee.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/isee.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/kfifo_buf.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/kfifo_buf.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/leds-mtk-disp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/leds-mtk-disp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/leds-mtk-pwm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/leds-mtk-pwm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/leds-mtk.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/leds-mtk.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/load_track.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/load_track.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/log_store.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/log_store.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mac80211.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mac80211.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mcDrvModule.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mcDrvModule.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mdp_drv_mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mdp_drv_mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mediatek-cpufreq-hw.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mediatek-cpufreq-hw.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mediatek-drm-gateic.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mediatek-drm-gateic.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mediatek-drm-panel-drv.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mediatek-drm-panel-drv.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mediatek-drm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mediatek-drm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/meta.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/meta.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mi-memory.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mi-memory.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mkp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mkp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mmprofile.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mmprofile.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mmqos-common.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mmqos-common.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mmqos-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mmqos-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/modules.alias:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.alias \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/modules.dep:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.dep \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/modules.load:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.load \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/modules.load.recovery:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.load.recovery \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/modules.softdep:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/modules.softdep \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/monitor_hang.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/monitor_hang.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mrdump.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mrdump.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6315-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6315-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6338-auxadc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6338-auxadc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6338-core.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6338-core.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6363-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6363-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6373-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6373-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6375-adc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6375-adc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6375-auxadc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6375-auxadc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6375-battery.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6375-battery.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6375-charger.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6375-charger.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6375.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6375.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6685-audclk.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6685-audclk.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6685-core.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6685-core.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mt6983_dcm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mt6983_dcm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-cmdq-drv-ext.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-cmdq-drv-ext.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-cqdma.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-cqdma.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-dvfsrc-devfreq.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-dvfsrc-devfreq.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-dvfsrc-helper.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-dvfsrc-helper.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-dvfsrc-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-dvfsrc-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-dvfsrc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-dvfsrc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-emi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-emi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-icc-core.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-icc-core.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-kpd.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-kpd.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mbox-mailbox.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mbox-mailbox.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mbox.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mbox.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mmc-autok.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mmc-autok.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mmc-dbg.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mmc-dbg.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mmc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mmc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mmdvfs-debug.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mmdvfs-debug.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mmdvfs.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mmdvfs.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mminfra-debug.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mminfra-debug.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mml-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mml-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-mml.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-mml.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-pm-domain-disable-unused.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-pm-domain-disable-unused.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-pmic-keys.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-pmic-keys.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-pmic-wrap.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-pmic-wrap.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-scpsys-bringup.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-scpsys-bringup.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-scpsys-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-scpsys-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-scpsys.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-scpsys.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-smi-dbg.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-smi-dbg.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-smi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-smi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-socinfo.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-socinfo.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-spmi-pmic-adc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-spmi-pmic-adc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-spmi-pmic.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-spmi-pmic.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-swpm-perf-arm-pmu.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-swpm-perf-arm-pmu.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-uart-apdma.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-uart-apdma.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk-vmm-spm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk-vmm-spm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_battery_oc_throttling.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_battery_oc_throttling.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_charger_algorithm_class.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_charger_algorithm_class.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_charger_framework.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_charger_framework.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_chg_type_det.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_chg_type_det.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_dcm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_dcm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_disp_notify.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_disp_notify.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_dramc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_dramc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_dynamic_loading_throttling.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_dynamic_loading_throttling.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_iommu.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_iommu.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_low_battery_throttling.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_low_battery_throttling.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_mdpm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_mdpm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_mm_heap.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_mm_heap.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_panel_ext.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_panel_ext.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pbm.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pbm.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pd_adapter.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pd_adapter.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pd_charging.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pd_charging.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pep.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pep.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pep20.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pep20.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_pep40.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_pep40.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_printk_ctrl.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_printk_ctrl.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_rpmsg_mbox.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_rpmsg_mbox.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_slbc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_slbc.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_sync.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_sync.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_tinysys_ipi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_tinysys_ipi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtk_wdt.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtk_wdt.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mtu3.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mtu3.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/mux_switch.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/mux_switch.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/nvmem_mtk-devinfo.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/nvmem_mtk-devinfo.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/panel-l2m-38-0a-0a-dsc-cmd.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/panel-l2m-38-0a-0a-dsc-cmd.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pd-chk-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pd-chk-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pd_dbg_info.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pd_dbg_info.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pd_single_cp_manager.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pd_single_cp_manager.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/phy-mtk-ufs.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/phy-mtk-ufs.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/phy-mtk-xsphy.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/phy-mtk-xsphy.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pidmap.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pidmap.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pinctrl-mt6373.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pinctrl-mt6373.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pinctrl-mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pinctrl-mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pinctrl-mtk-common-v2_debug.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pinctrl-mtk-common-v2_debug.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pinctrl-mtk-v2.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pinctrl-mtk-v2.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pmic_lbat_service.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pmic_lbat_service.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/ps5170.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/ps5170.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/pwm-mtk-disp.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/pwm-mtk-disp.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/reboot-mode.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/reboot-mode.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/regmap-spmi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/regmap-spmi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/regulator-vibrator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/regulator-vibrator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/reset-ti-syscon.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/reset-ti-syscon.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rpmb-mtk.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rpmb-mtk.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rpmb.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rpmb.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rt5133-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rt5133-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rt6160-regulator.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rt6160-regulator.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rt_pd_manager.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rt_pd_manager.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/rtc-mt6685.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/rtc-mt6685.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/sc8561.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/sc8561.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/sec-rng.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/sec-rng.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/sec.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/sec.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/simtray.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/simtray.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/slbc_ipi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/slbc_ipi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/slbc_mt6983.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/slbc_mt6983.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/spi-mt65xx.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/spi-mt65xx.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/spmi-mtk-mpu.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/spmi-mtk-mpu.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/spmi-mtk-pmif.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/spmi-mtk-pmif.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/syscon-reboot-mode.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/syscon-reboot-mode.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/system_heap.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/system_heap.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/tcpc_class.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/tcpc_class.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/tcpc_mt6375.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/tcpc_mt6375.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/tcpci_late_sync.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/tcpci_late_sync.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/teeperf.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/teeperf.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/tinysys-scmi.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/tinysys-scmi.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/ufs-mediatek-dbg.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/ufs-mediatek-dbg.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/ufs-mediatek-mod.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/ufs-mediatek-mod.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/uload_ind.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/uload_ind.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/usb_boost.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/usb_boost.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/usb_dp_selector.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/usb_dp_selector.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/vcp_status.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/vcp_status.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/wl2868c.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/wl2868c.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/xhci-mtk-hcd.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/xhci-mtk-hcd.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/xiaomi_touch.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/xiaomi_touch.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/zram.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/zram.ko \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk/lib/modules/zsmalloc.ko:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/zsmalloc.ko

# Xiaomi 12 Pro Dimensity (daumier) — LineageOS 设备树

适用于 **Xiaomi 12 Pro Dimensity Edition**，代号 `daumier`，型号 `2207122MC`。

目标系统：**LineageOS 23 / Android 16 (API 36)**

> ⚠️ **这不是一台普通的机器。** 在动手之前请务必读完
> [「版本结构」](#版本结构这台机器的特殊之处) 和 [「风险清单」](#风险清单) 两节。

---

## 设备规格

| 项目 | 值 | 来源 |
|---|---|---|
| SoC | MediaTek MT6983 (Dimensity 9000+) | `ro.board.platform` |
| CPU | 1× Cortex-X2 + 3× Cortex-A710 + 4× Cortex-A510 | ARM 官方 |
| GPU | Mali-G710 MC10 | — |
| 存储 | **UFS 3.1** | scatter + `ufs-mediatek-mod.ko` |
| 分区方案 | A/B + Virtual A/B + 动态分区 | LP metadata `flags=0x1` |
| 屏幕 | 1440×3200 OLED，默认跑 1080×2400 @420dpi | `persist.sys.miui_resolution` |
| 内存 | LPDDR5 | — |
| 电池 | 5160 mAh | — |
| NFC | **NXP SN110T** | `ro.vendor.se.chip.model` |
| 触觉 | Awinic AW8697 | `ueventd.mt6983.rc` |
| 指纹 | 屏下光学 | `ro.hardware.fp.fod=true` |
| TEE | Trustonic + Trusty 双栈 | `ueventd.mt6983.rc` |
| 内核 | Linux **5.10.226**-android12-9（GKI） | `boot.img` 内核字符串 |

**基线固件：`OS2.0.6.0.ULGCNXM`**（构建于 2025-06-17）

---

## 版本结构：这台机器的特殊之处

这是**整个设备树最关键的一点**。daumier 的原厂 ROM 不是"一个版本"，
而是上下两层不同版本拼起来的：

```
┌──────────────────────────────────────────────────────────┐
│ system / system_ext / product                            │
│   Android 14 · API 34 · 设备代号 "missi"（通用镜像）      │
│   fingerprint: Android/missi_phone_cn/missi:14/...       │
├──────────────────────────────────────────────────────────┤
│ vendor / vendor_dlkm / odm / odm_dlkm                    │
│   Android 12 · API 31 · 设备代号 "daumier"（机型专属）    │
│   fingerprint: Xiaomi/daumier/daumier:12/...             │
│   sepolicy 版本: 31.0                                     │
└──────────────────────────────────────────────────────────┘
```

Xiaomi 的 MTK 机型从 HyperOS 开始采用这个结构：**system 做成与机型无关的
通用镜像（GSI 血统），设备相关的一切都放在 vendor/odm 里**。连 `boot.img`
都是 GSI 的（`ro.product.bootimage.model=GSI on ARM64`）。

### 对设备树的三个直接影响

1. **`PRODUCT_SHIPPING_API_LEVEL := 31`** —— 必须按 vendor 的 API 等级来定，
   不是 system 的 34。已写在 `lineage_daumier.mk`。

2. **vendor 的 VINTF manifest 声明 `target-level="6"`**（FCM 6 / Android 12）。
   这是偏旧的 vendor 等级。

3. **vendor 的 SELinux 策略版本是 31.0**，而 LineageOS 23 的平台策略版本是
   36.0。两者差异靠 `plat_pub_versioned.cil` 的版本化机制消化。

### 这也解释了"移植"

所谓把 OS3/OS4 移植到 daumier，本质上就是**换掉上面那层通用 system，
保留下面的 daumier vendor**。理解这一点对排查问题很有帮助。

---

## 分区布局

数据来源：`MT6983_Android_scatter.txt` + `super.img` 的 LP metadata。

**本机是 UFS。** scatter 文件里同时有 `EMMC_*` 和 `UFS_LU*` 两套布局，
是同一个 scatter 的兼容写法，实际生效的是 UFS 那套。

### 物理分区（关键项）

| 分区 | 大小 | 说明 |
|---|---|---|
| `boot_a` / `boot_b` | 64 MiB | GKI 内核 + 通用 ramdisk |
| `vendor_boot_a` / `vendor_boot_b` | 64 MiB | **recovery 在这里** |
| `dtbo_a` / `dtbo_b` | 32 MiB | |
| `super` | 8704 MiB | 动态分区容器 |
| `metadata` | 32 MiB | |
| `userdata` | 12288 MiB | f2fs |
| `rescue` | 128 MiB | 挂载为 `/cache`（MTK 特有） |
| `cust` | 2048 MiB | |
| `persist` | 64 MiB | |
| `nvdata` / `nvcfg` | 64 / 32 MiB | |
| `md1img_a` / `_b` | 200 MiB | 基带固件 |
| `vbmeta` / `vbmeta_system` / `vbmeta_vendor` | 各 8 MiB | |

> **没有 `recovery` 分区，也没有 `init_boot`。**
> recovery 资源通过 `BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT`
> 打进 `vendor_boot`。

### 逻辑分区（在 super 里）

| 分区 | 大小 | 文件系统 |
|---|---|---|
| `product_a` | 4231.9 MiB | erofs |
| `vendor_a` | 1979.5 MiB | erofs |
| `system_a` | 765.1 MiB | erofs |
| `system_ext_a` | 637.5 MiB | erofs |
| `vendor_dlkm_a` | 18.6 MiB | erofs |
| `odm_a` | 17.0 MiB | erofs |
| `odm_dlkm_a` | 0.3 MiB | erofs |
| `mi_ext_a` | 0.1 MiB | erofs |

- 分区组：`main`（`main_a` / `main_b`）
- 只有 `_a` 槽有内容，`_b` 全为 0
- **所有逻辑分区都是 EROFS**，没有 ext4
- `mi_ext` 是小米专属扩展分区

### AVB 链结构

实测自三个 vbmeta 镜像。算法统一为 **SHA256_RSA2048**（libavb 1.0 / avbtool 1.2.0）。

```
vbmeta.img
  ├── CHAIN → boot            (rollback_index_location=3)
  ├── CHAIN → vbmeta_system   (2)  ──→ system, system_ext, product
  ├── CHAIN → vbmeta_vendor   (4)  ──→ vendor
  ├── HASH    vendor_boot
  └── HASHTREE mi_ext, odm, odm_dlkm, vendor_dlkm
```

---

## 内核与模块

| | 值 |
|---|---|
| 内核 | `5.10.226-android12-9-00047-g4968e29b7f92-ab12786767`（Google GKI） |
| 模块 vermagic | `5.10.226-android12-9-gac0ac333ab3c` |
| 分支 | `android12-5.10`（ACK） |

**模块分两批：**

| 位置 | 数量 | 阶段 |
|---|---|---|
| `vendor_boot` ramdisk → `lib/modules/` | **195** | 第一阶段 |
| `vendor_dlkm` 分区 → `lib/modules/` | **225** | 第二阶段 |

两边有 25 个重名。合计约 420 个 `.ko`。

> 注意：内核与模块的 localversion 里 git hash 不同
> （内核 `g4968e29b7f92`，模块 `gac0ac333ab3c`）。
> 这是 GKI 的常见现象（`-ab<构建号>` 段不参与匹配），
> 但**真机启动时需要确认模块能正常加载**。

---

## 目录结构

```
device/xiaomi/daumier/
├── Android.mk
├── AndroidProducts.mk          lunch 入口
├── BoardConfig.mk              ★ 分区表/引导头/AVB/文件系统
├── device.mk                   ★ HAL 清单/属性/VINTF
├── lineage_daumier.mk          ★ 产品定义
├── system.prop                 原厂属性
├── extract-files.py            blob 提取脚本
├── proprietary-files.txt       blob 清单
├── bootctrl/                   MTK UFS 开机控制 HAL
├── mtk_plpath_utils/           MTK preloader 路径工具
├── init/                       属性覆盖
├── prebuilt/
│   ├── dtb.img                 从 OS2.0.6.0 的 vendor_boot 提取（335112 字节）
│   ├── kernel                  从 OS2.0.6.0 的 boot.img 提取（19.6 MB，gzip）
│   ├── vendor_ramdisk/         设备独有的 ramdisk 内容（206 文件，38 MB）
│   ├── vendor_ramdisk_files.mk 上面那批文件的 PRODUCT_COPY_FILES 规则（206 条）
│   ├── Android.mk              ramdisk 里 19 个挂载点符号链接的还原规则
│   └── .symlinks.stamp         Android.mk 的占位源文件（0 字节）
├── configs/
│   └── vintf/
│       └── compatibility_matrix.xml  框架兼容性矩阵片段（52 个 HAL 条目）
├── overlay/frameworks/base/core/res/res/values/
│   └── config.xml              框架资源覆盖
├── rootdir/etc/
│   ├── fstab.mt6983            挂载表（同时作为 recovery.fstab）
│   └── vintf/manifest/
│       └── lineage_daumier.xml VINTF 追加声明（不覆盖原厂）
└── sepolicy/vendor/            SELinux 补充策略
```

### vendor_boot ramdisk 里保留了什么

原厂 `vendor_boot` 的 ramdisk 有 **879 个普通文件 + 210 个符号链接**，但**不能整份搬进来**。

其中 673 个文件是 AOSP recovery 的通用组件，LineageOS 会自己构建，并通过
`BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT` 与
`BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT` 合并进 vendor_boot。
若再由设备树复制一遍，两条规则会抢同一个目标文件。

| 原厂内容 | 数量 | 处置 |
|---|---|---|
| `lib/modules/`（195 `.ko` + 5 索引） | 200 | ✅ **保留** —— MTK 设备独有 |
| `first_stage_ramdisk/fstab.*` | 2 | ✅ **保留** —— 第一阶段挂载表 |
| `init.recovery.{mt6983,hardware}.rc` | 2 | ✅ **保留** —— recovery 硬件初始化 |
| `prop.default` | 1 | ✅ **保留** —— 原厂属性 |
| `system/etc/init/mtk-plpath-utils.rc` | 1 | ✅ **保留** —— plpath 服务定义 |
| `res/`（MIUI recovery 界面资源） | 500 | ❌ 剔除 —— AOSP 自己建 |
| `system/bin/`、`system/lib64/`、`system/etc/` | 143 | ❌ 剔除 —— AOSP recovery 组件 |
| `first_stage_ramdisk/system/` | 18 | ❌ 剔除 —— AOSP 自己建 |
| 原厂 `*_file_contexts`、`sepolicy` | 10 | ❌ 剔除 —— 原厂 recovery 策略 |
| `miui.factoryreset.{rc,fstab}` | 2 | ❌ 剔除 —— MIUI 专有 |

**符号链接只还原 19 个，不是 210 个。** 另外 191 个是指向 AOSP 可执行文件的
applet 链接（`date -> toybox`、`getprop -> toolbox`、`unzip -> ziptool`），
**不能照抄**：

1. 原厂那份是 Android 12 时代的，而现代 AOSP 已移除 `toolbox`、`ziptool`，
   照抄会产生**悬空链接**；
2. 目标文件（`system/bin/toybox` 等）由 AOSP 构建产出，设备树复制的那份
   反而会和它抢同一个目标路径。

保留的 19 个链接目标都是**路径**而非二进制（`bin`、`etc`、`init`、`d`、
`odm/*`、`odm_dlkm/etc`、`vendor_dlkm/etc`、`system_ext`、`bugreports`、
`default.prop`），重建它们是幂等的：AOSP 建过就原样覆盖，没建过就补上。

> ⚠ `prebuilt/Android.mk` 依赖 `TARGET_VENDOR_RAMDISK_OUT` 这个变量名，
> 它**未经编译验证**。规则里加了一道断言：安装前检查 `prop.default` 是否
> 已在目标目录里，不在就**直接让编译失败**并打印排查指引——避免符号链接被
> 静默写进错误的位置。


---

## VINTF：三种文件的分工

这块最容易搞混。AOSP 里有三种 VINTF 文件，**只有一种该由设备树提供**：

| 变量 | 安装位置 | 含义 | 本设备树 |
|---|---|---|---|
| `DEVICE_MANIFEST_FILE` | `vendor/etc/vintf/manifest.xml` | 厂商**提供**什么 | ❌ 不设，原厂已有一份 |
| `DEVICE_MATRIX_FILE` | `vendor/etc/vintf/compatibility_matrix.xml` | 厂商**要求**什么 | ❌ 不设，原厂已有一份 |
| `DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE` | 编译时合并进<br>`compatibility_matrix.device.xml` | 框架**要求**厂商提供什么 | ✅ 提供片段 |

**为什么前两个不能设**：原厂 `vendor/etc/vintf/manifest.xml` 声明了 40+ 个 HAL。
一旦设置 `DEVICE_MANIFEST_FILE`，编译产物会**覆盖**掉它，所有 HAL 声明丢失，
VINTF 校验全面失败。

**要追加声明怎么办**：AOSP 会把 `vendor/etc/vintf/manifest.xml` 和
`vendor/etc/vintf/manifest/*.xml` **合并**。所以用 `PRODUCT_COPY_FILES` 往
`manifest/` 子目录放文件即可，见 `rootdir/etc/vintf/manifest/lineage_daumier.xml`
（补充 boot HAL 的 1.1 / 1.2 接口）。

**框架矩阵片段**：`configs/vintf/compatibility_matrix.xml` 里有 52 个 HAL 条目。
其中只有 boot HAL 是 `optional="false"`（真正有约束力），其余都是
`optional="true"` 的**存档条目** —— VINTF 校验是单向的，optional 条目不参与
"设备必须提供"的判定，它们的作用是把原厂 vendor 实际提供的 HAL 记录在设备树里，
方便日后排查。

## 编译

### 依赖仓库

```bash
# 设备树（本仓库）
git clone <本仓库> device/xiaomi/daumier

# 厂商 blob（由 extract-files.py 生成，见下）
# → vendor/xiaomi/daumier

# 内核（见「内核」一节）
# → kernel/xiaomi/daumier
```

### 生成厂商 blob

```bash
# 先准备提取器（真正的实现不在设备树里）
git clone https://github.com/LineageOS/android_tools_extract-utils \
    -b lineage-23.0 tools/extract-utils

cd device/xiaomi/daumier
./extract-files.py ../../xiaomi-images/ ../../vendor/xiaomi/daumier
```

### 关于 proprietary-files.txt

清单共 **4836 条**，已逐条验证与原厂镜像一一对应。按分区：

| 分区 | 条目数 | 说明 |
|---|---|---|
| `vendor` | 4565 | 主体 |
| `vendor_dlkm` | 234 | 全部内核模块 |
| `odm` | 20 | |
| `mi_ext` | 12 | 见下方说明 |
| `odm_dlkm` | 5 | |

> **`mi_ext` 的 12 条是冗余的。** 本设备树不构建 `mi_ext` 分区
> （AOSP 没有对应变量，见 `BoardConfig.mk` 注释），所以这 12 个文件
> 提取出来也不会被安装。保留在清单里只是备查。

#### ⚠ 已知的体积优化点

原厂 `vendor` 里有 **639 个符号链接**，其中 **631 个的目标实体也在清单中**。
主要模式：

| 模式 | 数量 | 例子 |
|---|---|---|
| 指向 `mt6983/` 子目录 | 444 | `vendor/lib64/libGLES_mali.so` → `mt6983/libGLES_mali.so` |
| 指向 `toybox_vendor` | 174 | `vendor/bin/ls` → `toybox_vendor` |
| 指向 `toolbox` | 6 | |

提取器会把链接**解引用成实体文件**，也就是说这 631 个库会有两份内容，
vendor 仓库因此明显偏大。

**优化方法**：把链接条目从清单里去掉，改成在目标实体上加 `;SYMLINK=`：

```
# 改前（两份内容）
vendor/lib64/mt6983/libGLES_mali.so
vendor/lib64/libGLES_mali.so

# 改后（一份内容 + 一个链接）
vendor/lib64/mt6983/libGLES_mali.so;SYMLINK=vendor/lib64/libGLES_mali.so
```

清单里已经用这种写法处理了 5 个绝对路径链接（如
`vendor/lib/egl/mt6983/libGLES_mali.so;SYMLINK=vendor/lib/hw/vulkan.mt6983.so`），
可以直接参照。**当前清单虽然偏大但功能正确**，可以先用起来再优化。

### 开始编译

```bash
source build/envsetup.sh
lunch lineage_daumier-userdebug
mka bacon
```

> **磁盘需求**：源码 + `out/` 约需 **200 GB**。
> 建议放在外置硬盘或独立分区上编译。

---

## 风险清单

按严重程度排序。这些是"旧 vendor 配新 system"架构下已知的难点。

### 🔴 1. SELinux 策略版本差

vendor 声明 `plat_sepolicy_vers.txt = 31.0`，LineageOS 23 平台是 `36.0`。
若 Android 16 已不再提供 31.0 的版本化策略，`vendor_sepolicy.cil` 将无法编译。

**应对**：编译时若 sepolicy 报版本错误，需要检查
`BOARD_API_LEVEL` / `PLATFORM_SEPOLICY_VERSION` 的取值链。

### 🔴 2. `BOARD_API_LEVEL` 在 A16 不能手写

Android 16 的构建系统：

```make
ifdef RELEASE_BOARD_API_LEVEL
  ifdef BOARD_API_LEVEL
    $(error BOARD_API_LEVEL must not be set manually. The build system automatically sets this value.)
```

**应对**：本设备树已避开直接赋值。若需要调整 vendor API 等级，
需通过平台侧配置而非设备树。

### 🟡 3. VINTF 兼容性

vendor 的 `target-level="6"`（FCM 6）。若 Android 16 的框架兼容矩阵
不再包含 FCM 6，`init` 会报 VINTF 校验失败。

**应对**：可能需要放宽 `DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE`，
或使用 `PRODUCT_ENFORCE_VINTF_MANIFEST=false` 临时绕过。

### 🟡 4. HIDL HAL 支持

原厂 vendor 提供的 **全部是 HIDL HAL**（无 AIDL）。
AOSP 对 HIDL 的支持逐版本收窄。

**应对**：可能需要在设备树里补 AIDL 包装层，或依赖 AOSP 的 HIDL 兼容层。

### 🟡 5. 内核

本设备树使用**预编译内核**（`TARGET_PREBUILT_KERNEL := prebuilt/kernel`，
从原厂 `boot.img` 提取的 gzip `Image`）。若要自行编译内核，需要：

- MTK 的 BSP 补丁（`kernel-5.10` 的 MTK 分支，非纯 ACK）
- daumier 的 DTS 和 defconfig

通用 ACK（`ack-12-5.10`）**不包含** MTK BSP，无法直接编译出可用的内核。

### 🟢 6. 内核模块 vermagic

内核与模块的 localversion git hash 不同。GKI 通常容忍，
但需在真机验证 `dmesg` 里没有 `version magic` 报错。

### 🟡 7. `TARGET_VENDOR_RAMDISK_OUT` 变量名未验证

`prebuilt/Android.mk` 用这个变量定位 vendor ramdisk 的根目录，以还原
19 个挂载点符号链接。该变量名**未经编译验证**（写设备树时手上没有源码树）。

**应对**：规则里已加断言——安装前检查 `prop.default` 是否已在目标目录中，
不在就让编译失败并打印排查指引，避免符号链接被静默写进错误位置。
若报错，到 `build/make/core/` 里搜索 `vendor_ramdisk` 找到真正的变量名即可。

### 🟢 8. 已排除的两处结构性问题（留档）

排查过程中发现并已修掉，记录在此以便日后回溯：

1. **vendor_boot ramdisk 内容与 AOSP 撞车**。原计划整份复制原厂的
   879 个文件，但其中 673 个是 AOSP recovery 会自己构建的组件，会造成
   两条规则抢同一个目标文件。现已裁剪到 206 个设备独有文件。
2. **`recovery.fstab` 有两个来源**。`TARGET_RECOVERY_FSTAB` 与
   `recovery/root/system/etc/recovery.fstab` 写入同一路径，是隐性冲突。
   现已删除后者，统一由 `TARGET_RECOVERY_FSTAB` 提供。


---

## 数据来源与可复现性

本设备树的**每一个数值**都来自对原厂镜像 `OS2.0.6.0.ULGCNXM` 的实测，
不是猜测或从其他机型抄来的。分析过程使用的工具（纯 Python，无需 root）：

| 工具 | 作用 |
|---|---|
| `lpunpack.py` | 解析 sparse 镜像 + LP metadata，提取动态分区 |
| `bootimg.py` | 解析 boot / vendor_boot / dtbo 头部 |
| `cpio_extract.py` | 解 newc 格式 cpio（ramdisk） |
| `avbinfo.py` | 解析 AVB vbmeta 头部与描述符 |
| `parse_scatter.py` | 解析 MTK scatter 分区表 |

> **这些工具不在仓库里。** 它们位于本地工作区的 `.staging/tools/`
> （已被 `.gitignore` 排除），因为原厂镜像有 12 GB，不适合入库。
> 需要复核任何数值时，把它们连同镜像一起准备好即可重新推导。
>
> `.staging/` 的布局：
> ```
> .staging/
> ├── images/   原厂镜像（8.1 GB，未改动）
> ├── work/     提取出的 daumier blob 与 ramdisk
> ├── twrp/     TWRP 参考树
> └── tools/    上述分析工具 + 静态编译的 erofs 工具
> ```

---

## 致谢

- TWRP 设备树（MIUI 14 时期）提供了分区表结构、MTK bootctrl 实现
  和 `mtk_plpath_utils` 的参考。**结构可复用，但其中的 DTB、内核模块、
  fstab 和 HAL 清单均为旧版本，本设备树已按 OS2.0.6.0 全部重新推导。**
- LineageOS 项目

## 许可

Apache-2.0

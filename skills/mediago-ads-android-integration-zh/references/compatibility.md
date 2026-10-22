# 版本兼容规则与已验证矩阵

## 1. 核对原则（硬门禁）

- 修改 `build.gradle(.kts)` 或 `libs.versions.toml` 前，必须先核对 [`compatibility/compatibility.json`](../../../compatibility/compatibility.json)。
- 只推荐在支持窗口内、且 `verification_level` 为 `release_verified` 的版本组合。
- 不要假设“任意新版聚合 SDK + 任意旧版 Adapter”天然兼容。
- TopOn 必须先通过宿主现有的 `com.thinkup.sdk`（海外版）或 `com.anythink.sdk`（旧版）依赖区分分支，严禁混装。

## 2. 当前已验证版本基线（`release_verified`）

| 接入路径 | 核心 SDK (`cc.admaster.android:sdk`) | 聚合 Adapter 坐标与版本 | 对应聚合宿主 SDK 基线 | 验证等级 |
| --- | --- | --- | --- | --- |
| **直客接入 (Direct / Client Bidding)** | `2.0.38`（支持窗口：`>=2.0.20 <=2.0.38`） | 无（直接调用 `cc.admaster.android.proxy.api.*`） | 无 | `release_verified` |
| **AdMob 聚合** | `2.0.38` | `cc.admaster.android:adapter:1.0.0` | `com.google.android.gms:play-services-ads:23.0.0` | `release_verified` |
| **AppLovin MAX 聚合** | `2.0.38` | `cc.admaster.android:max-adapter:1.0.1` | `com.applovin:applovin-sdk:13.0.1` | `release_verified` |
| **TradPlus 聚合** | `2.0.38` | `cc.admaster.android:tradplus-adapter:0.0.6` | `com.tradplusad:tradplus:15.7.0.1` | `release_verified` |
| **TopOn 海外版聚合** | `2.0.38` | `cc.admaster.android:topon-adapter:0.0.4` | `com.thinkup.sdk:core-tpn:6.5.36`（兼容 `6.6.x`） | `release_verified` |
| **TopOn 旧版聚合** | `2.0.38` | `cc.admaster.android:topon-secmtp-adapter:0.0.3` | `com.anythink.sdk:core-tpn:6.5.10` | `release_verified` |

## 3. 工程编译兼容要求

- **`minSdkVersion`**：SDK 最低支持 `19`（推荐宿主 `21+`；若宿主为 Unity/团结引擎导出且含 Firebase，通常为 `23+`）。
- **`compileSdkVersion` / `targetSdkVersion`**：推荐 `34` 或 `35`。
- **传递依赖说明**：
  - SDK 内部使用 `androidx.media3:media3-exoplayer:1.4.0` 与 `com.google.guava:guava:33.3.1-android`。
  - 若宿主工程已有不同版本的 ExoPlayer / Media3，可通过 Gradle 依赖对齐或按需排查版本冲突。

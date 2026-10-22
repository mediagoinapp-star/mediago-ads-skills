# 聚合平台适配（Mediation Adapters）配置指南

当宿主项目通过三方聚合平台（AdMob / AppLovin MAX / TradPlus / TopOn）接入 MediaGo / AdMaster SDK 时，需要同时引入核心 SDK `cc.admaster.android:sdk` 与对应聚合平台的 Adapter 依赖，并在聚合后台配置对应的自定义 Adapter 类名与服务端参数。

---

## 1. 聚合 Adapter 依赖坐标总表

| 聚合平台 | 宿主聚合 SDK 特征 | Adapter Maven 坐标 | 推荐版本 | 核心 SDK 坐标 |
| --- | --- | --- | --- | --- |
| **Google AdMob** | `com.google.android.gms:play-services-ads` | `cc.admaster.android:adapter` | `1.0.0` | `cc.admaster.android:sdk:2.0.38` |
| **AppLovin MAX** | `com.applovin:applovin-sdk` | `cc.admaster.android:max-adapter` | `1.0.1` | `cc.admaster.android:sdk:2.0.38` |
| **TradPlus** | `com.tradplusad:tradplus` | `cc.admaster.android:tradplus-adapter` | `0.0.6` | `cc.admaster.android:sdk:2.0.38` |
| **TopOn 海外版 (ThinkUp)** | `com.thinkup.sdk:core-tpn` | `cc.admaster.android:topon-adapter` | `0.0.4` | `cc.admaster.android:sdk:2.0.38` |
| **TopOn 旧版 (AnyThink)** | `com.anythink.sdk:core-tpn` | `cc.admaster.android:topon-secmtp-adapter` | `0.0.3` | `cc.admaster.android:sdk:2.0.38` |

> **TopOn 分支强校验**：
> - 若宿主依赖为 `com.thinkup.sdk:*`（TopOn 海外独立包名），**必须**使用 `cc.admaster.android:topon-adapter:0.0.4`。
> - 若宿主依赖为 `com.anythink.sdk:*`（TopOn 旧版包名），**必须**使用 `cc.admaster.android:topon-secmtp-adapter:0.0.3`。
> - 严禁同时引入两个 TopOn Adapter。

---

## 2. 各聚合平台类名与后台参数配置

### 2.1 Google AdMob (`cc.admaster.android:adapter:1.0.0`)

- **Custom Event 入口类名（所有广告格式通用）**：
  - `com.google.ads.mediation.admaster.AdMasterMediationAdapter`
- **AdMob 后台 `Parameter` JSON 格式**：
  > 注意：AdMob Adapter 的广告位字段名固定为 **`ad_unit_id`**（而非 `placement_id`）！

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "ad_unit_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.2 AppLovin MAX (`cc.admaster.android:max-adapter:1.0.1`)

- **Custom Network Adapter 类名（所有广告格式通用）**：
  - `cc.admaster.android.max.adapter.AdMasterMaxMediationAdapter`
- **MAX 后台参数配置**：
  - 支持直接填写 App ID / Placement ID 字段，或在 `Custom Parameters` 中配置 JSON：

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.3 TradPlus (`cc.admaster.android:tradplus-adapter:0.0.6`)

TradPlus 支持 **Waterfall 标准加载** 与 **C2S Bidding（客户端竞价）** 两种模式，按广告格式在 TradPlus 后台配置以下自定义 Adapter 类名：

| 广告格式 | TradPlus 自定义 Adapter 类名 |
| --- | --- |
| **激励视频 (Rewarded)** | `cc.admaster.android.tradplus.adapter.AdMasterTPRewardedAdAdapter` |
| **插屏 (Interstitial)** | `cc.admaster.android.tradplus.adapter.AdMasterTPInterstitialAdapter` |
| **开屏 (Splash)** | `cc.admaster.android.tradplus.adapter.AdMasterTPSplashAdapter` |
| **横幅 (Banner)** | `cc.admaster.android.tradplus.adapter.AdMasterTPBannerAdapter` |
| **原生 (Native)** | `cc.admaster.android.tradplus.adapter.AdMasterTPNativeAdAdapter` |

- **TradPlus 后台自定义参数 JSON**：

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.4 TopOn 海外版 (`cc.admaster.android:topon-adapter:0.0.4`)

适用于宿主使用 `com.thinkup.sdk:*` 的工程，支持 **Waterfall** 与 **C2S Header Bidding**：

| 广告格式 | TopOn 海外版自定义 Adapter 类名 |
| --- | --- |
| **激励视频 (Rewarded)** | `cc.admaster.android.topon.adapter.AdMasterTopOnRewardedAdapter` |
| **插屏 (Interstitial)** | `cc.admaster.android.topon.adapter.AdMasterTopOnInterstitialAdapter` |
| **开屏 (Splash)** | `cc.admaster.android.topon.adapter.AdMasterTopOnSplashAdapter` |
| **横幅 (Banner)** | `cc.admaster.android.topon.adapter.AdMasterTopOnBannerAdapter` |
| **原生 (Native)** | `cc.admaster.android.topon.adapter.AdMasterTopOnNativeAdapter` |

- **TopOn 后台自定义参数 JSON**：

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.5 TopOn 旧版 (`cc.admaster.android:topon-secmtp-adapter:0.0.3`)

适用于宿主使用 `com.anythink.sdk:*` 的工程，支持 **Waterfall** 与 **C2S Header Bidding**：

| 广告格式 | TopOn 旧版自定义 Adapter 类名 |
| --- | --- |
| **激励视频 (Rewarded)** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpRewardedAdapter` |
| **插屏 (Interstitial)** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpInterstitialAdapter` |
| **开屏 (Splash)** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpSplashAdapter` |
| **横幅 (Banner)** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpBannerAdapter` |
| **原生 (Native)** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpNativeAdapter` |

- **TopOn 后台自定义参数 JSON**：

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

## 3. 聚合接入代码注意事项

1. **宿主业务代码无需混写直客加载调用**：走三方聚合时，业务层统一调用聚合 SDK（如 AdMob / MAX / TradPlus / TopOn）的加载与展示接口，由 Adapter 自动完成 `AdMaster.initialize(...)`、广告加载与 C2S 竞价回传。
2. **可选预初始化**：为降低首次广告请求耗时，宿主仍可在 `Application.onCreate()` 中提前调用 `AdMaster.initialize(this, appId, callback)`。

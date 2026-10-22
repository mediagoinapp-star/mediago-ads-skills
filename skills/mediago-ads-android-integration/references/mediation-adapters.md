# Mediation Adapters Configuration Guide

When integrating the MediaGo / AdMaster SDK through a third-party mediation platform (AdMob, AppLovin MAX, TradPlus, or TopOn), add both the core SDK (`cc.admaster.android:sdk`) and the matching mediation adapter dependency, then configure the custom adapter class names and server parameters in your mediation dashboard.

---

## 1. Mediation Adapter Maven Coordinates

| Mediation Platform | Host Mediation SDK Indicator | Adapter Maven Coordinate | Verified Version | Core SDK Coordinate |
| --- | --- | --- | --- | --- |
| **Google AdMob** | `com.google.android.gms:play-services-ads` | `cc.admaster.android:adapter` | `1.0.0` | `cc.admaster.android:sdk:2.0.38` |
| **AppLovin MAX** | `com.applovin:applovin-sdk` | `cc.admaster.android:max-adapter` | `1.0.1` | `cc.admaster.android:sdk:2.0.38` |
| **TradPlus** | `com.tradplusad:tradplus` | `cc.admaster.android:tradplus-adapter` | `0.0.6` | `cc.admaster.android:sdk:2.0.38` |
| **TopOn International (ThinkUp)** | `com.thinkup.sdk:core-tpn` | `cc.admaster.android:topon-adapter` | `0.0.4` | `cc.admaster.android:sdk:2.0.38` |
| **TopOn Legacy (AnyThink)** | `com.anythink.sdk:core-tpn` | `cc.admaster.android:topon-secmtp-adapter` | `0.0.3` | `cc.admaster.android:sdk:2.0.38` |

> **TopOn Variant Rule**:
> - If your project depends on `com.thinkup.sdk:*` (TopOn International / ThinkUp), you **must** use `cc.admaster.android:topon-adapter:0.0.4`.
> - If your project depends on `com.anythink.sdk:*` (TopOn Legacy / AnyThink), you **must** use `cc.admaster.android:topon-secmtp-adapter:0.0.3`.
> - Never include both TopOn adapters in the same project.

---

## 2. Adapter Class Names and Dashboard Server Parameters

### 2.1 Google AdMob (`cc.admaster.android:adapter:1.0.0`)

- **Custom Event Adapter Class Name (all formats)**:
  - `com.google.ads.mediation.admaster.AdMasterMediationAdapter`
- **AdMob Dashboard `Parameter` JSON**:
  > Note: AdMob adapter requires the placement key to be named **`ad_unit_id`** (not `placement_id`).

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "ad_unit_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.2 AppLovin MAX (`cc.admaster.android:max-adapter:1.0.1`)

- **Custom Network Adapter Class Name (all formats)**:
  - `cc.admaster.android.max.adapter.AdMasterMaxMediationAdapter`
- **MAX Dashboard Server Parameters**:
  - Pass `app_id` and `placement_id` via the dashboard fields or as JSON in `Custom Parameters`:

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.3 TradPlus (`cc.admaster.android:tradplus-adapter:0.0.6`)

Supports both **Waterfall** and **C2S Bidding**. Configure the following custom adapter class names per ad format in the TradPlus dashboard:

| Ad Format | TradPlus Custom Adapter Class Name |
| --- | --- |
| **Rewarded** | `cc.admaster.android.tradplus.adapter.AdMasterTPRewardedAdAdapter` |
| **Interstitial** | `cc.admaster.android.tradplus.adapter.AdMasterTPInterstitialAdapter` |
| **Splash** | `cc.admaster.android.tradplus.adapter.AdMasterTPSplashAdapter` |
| **Banner** | `cc.admaster.android.tradplus.adapter.AdMasterTPBannerAdapter` |
| **Native** | `cc.admaster.android.tradplus.adapter.AdMasterTPNativeAdAdapter` |

- **TradPlus Dashboard Server Parameter JSON**:

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.4 TopOn International (`cc.admaster.android:topon-adapter:0.0.4`)

For host projects using `com.thinkup.sdk:*`. Supports both **Waterfall** and **C2S Header Bidding**:

| Ad Format | TopOn International Custom Adapter Class Name |
| --- | --- |
| **Rewarded** | `cc.admaster.android.topon.adapter.AdMasterTopOnRewardedAdapter` |
| **Interstitial** | `cc.admaster.android.topon.adapter.AdMasterTopOnInterstitialAdapter` |
| **Splash** | `cc.admaster.android.topon.adapter.AdMasterTopOnSplashAdapter` |
| **Banner** | `cc.admaster.android.topon.adapter.AdMasterTopOnBannerAdapter` |
| **Native** | `cc.admaster.android.topon.adapter.AdMasterTopOnNativeAdapter` |

- **TopOn Dashboard Server Parameter JSON**:

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

### 2.5 TopOn Legacy (`cc.admaster.android:topon-secmtp-adapter:0.0.3`)

For host projects using `com.anythink.sdk:*`. Supports both **Waterfall** and **C2S Header Bidding**:

| Ad Format | TopOn Legacy Custom Adapter Class Name |
| --- | --- |
| **Rewarded** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpRewardedAdapter` |
| **Interstitial** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpInterstitialAdapter` |
| **Splash** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpSplashAdapter` |
| **Banner** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpBannerAdapter` |
| **Native** | `cc.admaster.android.topon.secmtp.adapter.AdMasterSecmtpNativeAdapter` |

- **TopOn Dashboard Server Parameter JSON**:

```json
{
  "app_id": "YOUR_ADMASTER_APP_ID",
  "placement_id": "YOUR_ADMASTER_AD_UNIT_ID"
}
```

---

## 3. Implementation Notes for Mediation

1. **Do Not Mix Direct Load Calls**: When using third-party mediation, load and show ads exclusively through your mediation SDK's public APIs. The adapter handles `AdMaster.initialize(...)`, ad loading, and C2S bidding notifications automatically.
2. **Optional Pre-Initialization**: To reduce first-request latency, you may optionally call `AdMaster.initialize(this, appId, callback)` in `Application.onCreate()`.

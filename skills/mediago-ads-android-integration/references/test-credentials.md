# Official Test Credentials and Verification Guidelines

When verifying a new integration or diagnosing whether a `2000` / `1040004` no-fill response on production IDs is caused by targeting/budget vs. client code, use the official test `appId` and placement IDs (`adUnitId`) below to verify end-to-end loading, rendering, and callbacks.

---

## 1. Official Android Test App ID and Placement IDs

| Parameter Type | Target SDK Class | Official Test Value (`String`) | Format Rule |
| --- | --- | --- | --- |
| **Test App ID (`appsid`)** | `AdMaster.initialize(...)` | `ad2fd73dca2ccffd312495bcd8a33d29` | 32-character lowercase hex string (`^[a-f0-9]{32}$`) |
| **Rewarded Video** | `RewardedAd` | `100090001` | Numeric string (never parse as `int`; preserve leading zeros) |
| **Interstitial** | `ExpressInterstitialAd` | `100090002` | Numeric string |
| **Native** | `NativeAdLoader` / `NativeAd` | `100090003` | Numeric string |
| **Splash** | `SplashAd` | `100090004` | Numeric string |
| **Banner** | `AdMBannerView` / `BannerAdLoader` | `100090005` | Numeric string |

---

## 2. Enabling Debug Logs

During development and integration testing, enable SDK debug logging to inspect request, caching, and callback events in Logcat:

```java
import cc.admaster.android.proxy.api.AdMasterSetting;

if (BuildConfig.DEBUG) {
    AdMasterSetting.getInstance().setDebugLogEnable(true);
}
```

---

## 3. Mandatory Guardrails for Test Credentials

1. **Never Ship Test IDs to Production**: The test `appId` (`ad2fd73dca2ccffd312495bcd8a33d29`) and test placement IDs (`100090001`–`100090005`) are strictly for integration verification and do not generate revenue.
2. **Never Overwrite Production IDs Silently**: If the host project already has production IDs configured, gate test IDs behind `BuildConfig.DEBUG` or use them only temporarily to isolate no-fill issues, then restore production IDs before release.
3. **Always Keep Placement IDs as `String`**: Production placement IDs may contain leading zeros (e.g., `"057362412"`). Always store and pass them as `String` without converting to integer types.

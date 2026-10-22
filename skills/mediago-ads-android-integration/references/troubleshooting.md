# Error Codes and Troubleshooting Guide

## 1. Client SDK Error Codes (`AdError` 7-Digit Codes)

These error codes are defined in `cc.admaster.android.proxy.api.AdError` and retrieved via `error.getCode()` and `error.getMessage()`:

| Error Code (`int`) | Constant Name | Meaning | Root Cause & Fix |
| --- | --- | --- | --- |
| `1010001` | `ERROR_INTERFACE` | Interface invocation error | Verify input parameters (e.g., non-empty `adUnitId`) and SDK state |
| `1020001` | `ERROR_NETWORK` | Network connection error | Check device internet connectivity, proxy certificates, and `INTERNET` permission |
| `1030001` | `ERROR_UNREGISTER_ACTIVITY` | Ad Activity not registered | Ensure `MobRewardVideoActivity` / `AppActivity` or custom subclass is declared in `AndroidManifest.xml` |
| `1030002` | `ERROR_UNREGISTER_PROVIDER` | Provider not registered | Check manifest merge rules to ensure SDK providers are not stripped |
| **`1030003`** | **`ERROR_NOT_INITIALIZED`** | **SDK not initialized** | **Common**: `load(...)` was called before `AdMaster.InitCallback.onInitialized()` fired, or called in a secondary process where `AdMaster.initialize(...)` was not run |
| `1040001` | `ERROR_TIMEOUT` | Ad request timed out | Request did not complete within the timeout window; check network latency or increase `AdRequest.Builder().setTimeout(ms)` |
| `1040002` | `ERROR_REQUEST_PARAM` | Invalid request parameters | Check that `appId` (32-char lowercase hex) and `adUnitId` (numeric string) are valid and belong to the same account |
| `1040003` | `ERROR_REQUEST_EXCESSIVE` | Excessive request frequency | Avoid immediate tight-loop retries inside `onAdFailedToLoad`; use exponential backoff |
| `1040004` | `ERROR_NO_AD` | No ad returned | No fill for the current request; switch to official test IDs (`references/test-credentials.md`) to verify your integration code |
| **`1040005`** | **`ERROR_ALREADY_LOADING`** | **Placement already loading** | **Common**: A request for the same `(adFormat, adUnitId)` is already in flight. Wait for `onAdLoaded` or `onAdFailedToLoad` before requesting again |
| **`1040006`** | **`ERROR_AD_EXPIRED`** | **Ad expired** | The cached ad has expired. Always check `!ad.isExpired()` before `show(...)`; if expired, call `ad.destroy()` and reload |
| `3010001` | `ERROR_PARSE` | Response parsing failed | Server response was malformed or intercepted by a proxy |
| **`3010002`** | **`ERROR_MATERIAL_EMPTY`** | **Ad creative material empty** | Ad response contained no renderable creative assets (treated as No Fill) |
| `3020001` | `ERROR_FILTER_APP` | Filtered by app condition | Target app package is already installed or filtered by targeting rules |
| `3020002` | `ERROR_FILTER_SIZE` | Container size unfit | Splash or Banner container dimensions are too small or unmeasured |
| `3030001` | `ERROR_CACHE_NOT_COMPLETED` | Asset caching incomplete | Attempted to display before media assets finished caching |
| **`3030002`** | **`ERROR_CACHE_FAILED`** | **Asset caching failed** | Failed to download video/image creative from CDN |
| **`3040001`** | **`ERROR_DISPLAY_STANDARD_UNFIT`** | **Display conditions not met** | Host `Activity` is finishing/destroyed, or container `ViewGroup` is not attached/visible |
| **`3040002`** | **`ERROR_DISPLAY_FAILED`** | **Ad display failed** | Ad is not ready (`!ad.isReady()`), was already shown, or was destroyed |
| `3040003` | `ERROR_RENDER_FAILED` | Template/view render failed | WebView or native view rendering error |
| **`3040004`** | **`ERROR_SPLASH_CONTAINER_INVISIBLE`** | **Splash container invisible** | `SplashAd.show(container)` was called while `container` was detached, `visibility != VISIBLE`, or had `0` width/height |
| `4030007` | `ERROR_AD_DISMISS_CLOSED` | Ad closed during load/prepare | Container or host activity was closed before display completed |

---

## 2. Server Error Codes (4-Digit Codes)

When the ad server returns a non-zero status code, `AdError.getCode()` forwards the 4-digit server code:

| Code Range | Category | Cause & Resolution |
| --- | --- | --- |
| **`2000`** | **DSP No Fill** | The request reached the server properly, but no matching ad was filled. **Switch to official test IDs (`references/test-credentials.md`) to verify end-to-end rendering and callbacks.** |
| **`3000 ~ 3004`** | **ADX Filter (No Fill)** | Frequency cap, high `bidFloor`, or geo/device targeting filter |
| **`4000 ~ 4004`** | **Bad Request Parameters** | Invalid `appId` or `adUnitId`, inactive placement, or ad format mismatch (e.g., loading a Rewarded placement ID with `ExpressInterstitialAd`) |
| **`1000 ~ 1999`** | **Server Internal Error** | Transient server-side error; retry with backoff |

---

## 3. Mediation Adapter Error Codes

- **AdMob Adapter (`com.google.ads.mediation.admaster`)**:
  - `100` (`ERROR_ADMASTER_SDK`): Underlying AdMaster SDK error
  - `101` (`ERROR_INVALID_SERVER_PARAMETERS`): Missing `app_id` or `ad_unit_id` in AdMob Custom Event `Parameter` JSON (note: AdMob requires `ad_unit_id`)
  - `102` (`ERROR_RESPONSE_EMPTY`): Empty ad response
  - `103` (`ERROR_AD_NOT_READY`): Ad not ready when `show` was called
  - `104` (`ERROR_CONTEXT_NOT_ACTIVITY`): `Context` is not an `Activity`
- **TopOn Adapter (`cc.admaster.android.topon.*`)**:
  - `1001` (`ERROR_CONFIG`): Missing `app_id` or `placement_id` in TopOn server extras
  - `1002` (`ERROR_INIT_FAILED`): SDK initialization failed
  - `1003` / `1004`: Load or bidding request already in progress
  - `1005` (`ERROR_NO_AD`): No ad fill
  - `1006` (`ERROR_SHOW_FAILED`): Ad display failed
  - `1007` (`ERROR_AD_EXPIRED`): Ad expired

---

## 4. Four-Step Diagnostic Workflow

1. **Enable Debug Logging**: Before calling `AdMaster.initialize(...)` in debug builds, enable verbose logging:
   ```java
   AdMasterSetting.getInstance().setDebugLogEnable(true);
   ```
2. **Verify Initialization First**: Check Logcat to confirm `AdMaster.InitCallback.onInitialized()` fired before any `load(...)` call.
3. **Distinguish Integration Bugs from Server No-Fill**:
   - Codes `1030003`, `1040002`, `4000~4004`, `101`, `1001` indicate **client call sequence or parameter configuration bugs**.
   - Codes `2000`, `3000~3004`, `1040004` indicate **the request succeeded technically, but the server had no fill**. Temporarily switch to the official test credentials in `references/test-credentials.md` to verify ad rendering and callbacks.
4. **Check View Registration & Display Calls**:
   - For `NativeAd`, ensure `ad.registerViewForInteraction(container, clickableViews, listener)` is called.
   - For `SplashAd`, if using `SplashAd.load(...)`, ensure `ad.show(container)` is called inside `onAdLoaded`.

# Direct Integration and SDK Initialization

## 1. Public Package and Entry Classes

All public SDK APIs reside in `cc.admaster.android.proxy.api`:

- `cc.admaster.android.proxy.api.AdMaster`: SDK initialization, readiness check, and version query
- `cc.admaster.android.proxy.api.AdMasterSetting`: Global singleton for debug logging, test mode, and personalized ad restrictions
- `cc.admaster.android.proxy.api.AdRequest`: Immutable ad request configuration built via `AdRequest.Builder`
- `cc.admaster.android.proxy.api.AdError`: Unified error object (`getCode()`, `getMessage()`)

## 2. Initialization Timing and Signatures

- **When to Initialize**: Must be called before loading any ads, ideally on the main thread in `Application.onCreate()` (or immediately after user consent is granted if a privacy consent dialog blocks startup).
- **Method Signatures**:

```java
package cc.admaster.android.proxy.api;

public final class AdMaster {
    public static void initialize(
            @NonNull Context context,
            @NonNull String appsid,
            @Nullable InitCallback callback);

    public static boolean isInitialized();

    @NonNull
    public static String getVersion();

    public interface InitCallback {
        void onInitialized();
        void onFailed(int code, String msg);
    }
}
```

> **Important**: The success callback on `AdMaster.InitCallback` is `onInitialized()`, and the failure callback is `onFailed(int code, String msg)`. Do not call ad `load(...)` methods before `onInitialized()` fires, or the SDK will immediately fail with `AdError.ERROR_NOT_INITIALIZED (1030003)`.

## 3. Application Initialization Examples

### Java Example

```java
package com.example.app;

import android.app.Application;
import android.util.Log;

import cc.admaster.android.proxy.api.AdMaster;
import cc.admaster.android.proxy.api.AdMasterSetting;

public class MyApplication extends Application {
    private static final String TAG = "AdMasterInit";
    // Official test App ID for development; replace with your production App ID before release
    private static final String ADMASTER_APP_ID = "ad2fd73dca2ccffd312495bcd8a33d29";

    @Override
    public void onCreate() {
        super.onCreate();

        // Enable debug logs only in debug builds
        if (BuildConfig.DEBUG) {
            AdMasterSetting.getInstance().setDebugLogEnable(true);
        }

        AdMaster.initialize(this, ADMASTER_APP_ID, new AdMaster.InitCallback() {
            @Override
            public void onInitialized() {
                Log.i(TAG, "AdMaster SDK initialized, version=" + AdMaster.getVersion());
                // Safe to trigger initial ad preloads here
            }

            @Override
            public void onFailed(int code, String msg) {
                Log.e(TAG, "AdMaster SDK init failed: code=" + code + ", msg=" + msg);
            }
        });
    }
}
```

### Kotlin Example

```kotlin
package com.example.app

import android.app.Application
import android.util.Log
import cc.admaster.android.proxy.api.AdMaster
import cc.admaster.android.proxy.api.AdMasterSetting

class MyApplication : Application() {
    companion object {
        private const val TAG = "AdMasterInit"
        private const val ADMASTER_APP_ID = "ad2fd73dca2ccffd312495bcd8a33d29"
    }

    override fun onCreate() {
        super.onCreate()

        if (BuildConfig.DEBUG) {
            AdMasterSetting.getInstance().setDebugLogEnable(true)
        }

        AdMaster.initialize(this, ADMASTER_APP_ID, object : AdMaster.InitCallback {
            override fun onInitialized() {
                Log.i(TAG, "AdMaster SDK initialized, version=${AdMaster.getVersion()}")
            }

            override fun onFailed(code: Int, msg: String?) {
                Log.e(TAG, "AdMaster SDK init failed: code=$code, msg=$msg")
            }
        })
    }
}
```

## 4. Building an `AdRequest`

All ad format `load` APIs accept an `AdRequest` instance:

```java
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.SplashAd;

// Standard request
AdRequest request = new AdRequest.Builder().build();

// Request with optional parameters
AdRequest customRequest = new AdRequest.Builder()
        .setBidFloor(100)                              // Optional: bid floor (integer cents; default -1)
        .setTimeout(5000)                              // Optional: request timeout in ms (primarily for SplashAd)
        .setWidth(1080)                                // Optional: preferred container width in px
        .setHeight(1920)                               // Optional: preferred container height in px
        .addExtra(SplashAd.KEY_IMMERSIVE, "true")      // Optional: immersive mode for SplashAd
        .addCustomExt("scene", "level_complete")       // Optional: custom pass-through key-value pair
        .build();
```

## 5. Critical Guardrails for Direct Integration

1. **Wait for Initialization**: Check `AdMaster.isInitialized()` or wait for `InitCallback.onInitialized()` before issuing ad requests.
2. **No Concurrent Loads on the Same Placement**: The SDK guards concurrent loads per `(adFormat, adUnitId)` via `AdLoadRegistry`. Calling `load` while a request for the same `adUnitId` is already in flight immediately fails with `AdError.ERROR_ALREADY_LOADING (1040005)`.
3. **Validate Readiness & Activity Before Show**: For fullscreen ads (`ExpressInterstitialAd`, `RewardedAd`, `SplashAd`), always verify `ad != null && ad.isReady() && !ad.isExpired()` and ensure `!activity.isFinishing() && !activity.isDestroyed()` before calling `show(...)`.
4. **Always Destroy Used Ads**: Call `ad.destroy()` and clear references in `onAdDismissedFullScreenContent`, `onAdFailedToShowFullScreenContent`, or `Activity.onDestroy()` to prevent memory leaks.

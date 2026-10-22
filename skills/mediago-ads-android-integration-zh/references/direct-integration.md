# 直客接入（Direct Integration）与 SDK 初始化

## 1. 核心公开包名与入口类

所有公开 API 均位于包 `cc.admaster.android.proxy.api` 下：

- `cc.admaster.android.proxy.api.AdMaster`：SDK 初始化、状态查询与版本号入口
- `cc.admaster.android.proxy.api.AdMasterSetting`：全局调试日志、测试模式与个性化广告限制开关
- `cc.admaster.android.proxy.api.AdRequest`：不可变广告请求参数对象（通过 `AdRequest.Builder` 构建）
- `cc.admaster.android.proxy.api.AdError`：统一错误对象（`getCode()`、`getMessage()`）

## 2. 初始化时机与方法签名

- **初始化时机**：必须在发起任何广告请求前完成初始化，推荐在 `Application.onCreate()` 主线程中调用（若存在用户隐私授权弹窗，可在用户同意后第一时间调用）。
- **方法签名**：

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

> **注意**：`AdMaster.InitCallback` 的成功回调方法名为 `onInitialized()`，失败回调为 `onFailed(int code, String msg)`。请勿在 `onInitialized()` 完成前直接调用 `load`，否则会立即触发 `AdError.ERROR_NOT_INITIALIZED (1030003)`。

## 3. Application 初始化代码示例

### Java 示例

```java
package com.example.app;

import android.app.Application;
import android.util.Log;

import cc.admaster.android.proxy.api.AdMaster;
import cc.admaster.android.proxy.api.AdMasterSetting;

public class MyApplication extends Application {
    private static final String TAG = "AdMasterInit";
    // 开发联调期可使用官方测试 App ID：ad2fd73dca2ccffd312495bcd8a33d29，上线前替换为正式 App ID
    private static final String ADMASTER_APP_ID = "ad2fd73dca2ccffd312495bcd8a33d29";

    @Override
    public void onCreate() {
        super.onCreate();

        // 仅在 Debug 构建开启 SDK 调试日志，发版请关闭
        if (BuildConfig.DEBUG) {
            AdMasterSetting.getInstance().setDebugLogEnable(true);
        }

        AdMaster.initialize(this, ADMASTER_APP_ID, new AdMaster.InitCallback() {
            @Override
            public void onInitialized() {
                Log.i(TAG, "AdMaster SDK initialized, version=" + AdMaster.getVersion());
                // 可在此处启动首屏广告加载或通知广告管理器预加载
            }

            @Override
            public void onFailed(int code, String msg) {
                Log.e(TAG, "AdMaster SDK init failed: code=" + code + ", msg=" + msg);
            }
        });
    }
}
```

### Kotlin 示例

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

## 4. 构建 `AdRequest` 请求对象

所有广告格式的 `load` 方法均接收 `AdRequest` 实例：

```java
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.SplashAd;

// 基础请求（最常用）
AdRequest request = new AdRequest.Builder().build();

// 带可选高级参数的请求
AdRequest customRequest = new AdRequest.Builder()
        .setBidFloor(100)                              // 可选：底价（单位：分/美分整数，默认 -1 不设底价）
        .setTimeout(5000)                              // 可选：请求超时时间（毫秒，主に SplashAd 使用）
        .setWidth(1080)                                // 可选：期望容器宽度（px）
        .setHeight(1920)                               // 可选：期望容器高度（px）
        .addExtra(SplashAd.KEY_IMMERSIVE, "true")      // 可选：开屏沉浸式额外参数
        .addCustomExt("scene", "level_complete")       // 可选：自定义透传扩展键值对
        .build();
```

## 5. 直客接入关键守卫

1. **禁止未初始化请求**：调用各广告位 `load(...)` 前建议检查 `AdMaster.isInitialized()`，或在 `InitCallback.onInitialized()` 后再触发预加载队列。
2. **禁止同一广告位并发加载**：SDK 内部通过 `AdLoadRegistry` 对同一 `(adFormat, adUnitId)` 进行并发保护，若上一次加载未结束再次请求同一 `adUnitId`，将返回 `AdError.ERROR_ALREADY_LOADING (1040005)`。
3. **展示前有效性校验**：全屏广告（插屏/激励/开屏）在调用 `show(...)` 前必须检查 `ad != null && ad.isReady() && !ad.isExpired()`，并确认传入的 `Activity` 未处于销毁状态（`!activity.isFinishing() && !activity.isDestroyed()`）。
4. **生命周期及时释放**：广告关闭（`onAdDismissedFullScreenContent`）、展示失败（`onAdFailedToShowFullScreenContent`）或宿主页面销毁（`onDestroy`）时，必须调用 `ad.destroy()` 并将引用置空。

# 客户端竞价（Client Bidding）契约与接入指南

当宿主使用**自研聚合**或需要在客户端直接拿 SDK 返回的实时价格参与比价时，使用本指南中的 `IBiddingAd` 接口契约。
（注：若宿主使用 TradPlus / TopOn / MAX / AdMob 官方或自定义 Adapter，竞价回传已由各 Adapter 内部封装，无需业务层手写 `notifyWin` / `notifyLoss`。）

## 1. 核心接口与方法签名

`SplashAd`、`ExpressInterstitialAd`、`RewardedAd`、`BannerAd`、`NativeAdLoader` 均实现了 `cc.admaster.android.proxy.api.IBiddingAd` 接口（`NativeAd` 也提供同名方法）：

```java
package cc.admaster.android.proxy.api;

public interface IBiddingAd {
    @NonNull
    ADMResponseInfo getResponseInfo();

    void notifyWin(@Nullable Map<String, Object> secondInfo, @Nullable BiddingCallback callback);

    void notifyLoss(@Nullable Map<String, Object> winInfo, @Nullable BiddingCallback callback);
}
```

关联数据类与回调：

```java
package cc.admaster.android.proxy.api;

public final class ADMResponseInfo {
    @Nullable public String getAdUnitTag();
    @Nullable public String getResponseIdentifier();
    @Nullable public String getEcpmLevel();      // 明文 eCPM 价格字符串（单位：分/美分，如 "150"）
    @Nullable public String getEncryptedEcpm();  // 加密 eCPM
}

public interface BiddingCallback {
    void onBiddingResult(boolean result, @Nullable String message, @Nullable HashMap<String, Object> ext);
}
```

## 2. 竞价参数校验规则（`BiddingUtils` 强校验）

SDK 内部的 `BiddingUtils.checkBiddingParams` 会对传入 `notifyWin` 和 `notifyLoss` 的 `Map<String, Object>` 进行**严格参数校验**。若参数类型或格式不合法，`BiddingCallback.onBiddingResult(false, ...)` 会直接返回失败且不会上报竞价日志！

### 2.1 竞胜通知 `notifyWin(secondInfo, callback)` 参数表

在广告比价胜出后、**调用 `show(...)` 展示之前**调用：

| Key | 是否必传 | 类型要求 | 说明 |
| --- | --- | --- | --- |
| `"ecpm"` | **必传** | 正整数或正整数字符串（**严禁带小数点**，且值 `> 0`） | 二价（Second Price）或胜出价，单位为**分**（如 `"120"` 或 `120`；若传 `"120.5"` 或 `"0"` 会校验失败） |
| `"min_to_win"` | 可选 | 非负整数或整数字符串（`>= 0`，严禁带小数点） | 最小获胜价格（也可使用别名 `"minimum_bid_to_win"`） |
| `"adn"` | 可选 | `Integer` / `String` | 二价广告网络标识（如 `2` 表示三方 ADN） |

### 2.2 竞败通知 `notifyLoss(winInfo, callback)` 参数表

在广告比价落败后调用，调用后**必须立即调用 `ad.destroy()` 释放广告实例**：

| Key | 是否必传 | 类型要求 | 说明 |
| --- | --- | --- | --- |
| `"ecpm"` | **必传** | 正整数或正整数字符串（**严禁带小数点**，且值 `> 0`） | 胜出方的一价（Winning Price），单位为**分**（若无胜出价可传兜底正整数如 `100`） |
| `"reason"` | **必传** | 非负整数或整数字符串（**严禁带小数点**，`>= 0`） | 竞败原因码（推荐使用 OpenRTB 标准整数码，见下表） |
| `"min_to_win"` | 可选 | 非负整数或整数字符串（`>= 0`，严禁带小数点） | 最小获胜价格 |
| `"adn"` | 可选 | `Integer` / `String` | 胜出方广告网络标识 |

常用 `"reason"` 竞败原因码：
- `102`：Header Bidding / C2S 比价价格低于其他出价方（最常用默认码）
- `103`：常规瀑布流（Waterfall）价格低于高层级广告源
- `2`：竞价超时（Timeout）
- `5`：广告已过期（Expired）

## 3. 标准接入时序与代码示例

### 完整时序

1. 调用广告 `load(...)` 请求广告。
2. 在 `onAdLoaded(ad)` 中通过 `ad.getResponseInfo().getEcpmLevel()` 读取当前广告出价。
3. 参与宿主聚合比价：
   - **若竞胜（Win）**：先校验 `!ad.isExpired()`，调用 `ad.notifyWin(secondInfo, callback)`，随后调用 `ad.show(...)`。
   - **若竞败（Loss）**：调用 `ad.notifyLoss(winInfo, callback)`，随后立即调用 `ad.destroy()` 并置空引用。

### Java 示例（以 `RewardedAd` 为例）

```java
import java.util.HashMap;
import java.util.Map;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdLoadCallback;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.RewardedAd;

public class BiddingExample {

    private RewardedAd mRewardedAd;

    public void requestBiddingAd(Context context, String adUnitId) {
        AdRequest request = new AdRequest.Builder().build();
        RewardedAd.load(context, adUnitId, request, new AdLoadCallback<RewardedAd>() {
            @Override
            public void onAdLoaded(@NonNull RewardedAd ad) {
                mRewardedAd = ad;
                // 1. 读取返回的 eCPM（单位：分，字符串格式如 "180"）
                String ecpmStr = ad.getResponseInfo().getEcpmLevel();
                int bidPriceCents = parsePositiveIntOrDefault(ecpmStr, 0);

                // 将 bidPriceCents 交由宿主聚合引擎比价...
            }

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {
                // 未填充或请求失败，不参与比价
            }
        });
    }

    // 2A. 竞胜分支：先回传 notifyWin，再展示
    public void onBidWinAndShow(Activity activity, int secondPriceCents) {
        if (mRewardedAd == null || !mRewardedAd.isReady() || mRewardedAd.isExpired()) {
            return;
        }
        Map<String, Object> secondInfo = new HashMap<>();
        // 注意："ecpm" 必须为正整数（> 0）且不含小数点
        secondInfo.put("ecpm", Math.max(1, secondPriceCents));
        secondInfo.put("min_to_win", Math.max(1, secondPriceCents + 1));

        mRewardedAd.notifyWin(secondInfo, (result, message, ext) -> {
            Log.d("Bidding", "notifyWin result=" + result + ", msg=" + message);
        });

        mRewardedAd.show(activity, reward -> {
            // 发放激励奖励
        });
    }

    // 2B. 竞败分支：回传 notifyLoss 后立即销毁
    public void onBidLoss(int winnerPriceCents) {
        if (mRewardedAd == null) {
            return;
        }
        Map<String, Object> winInfo = new HashMap<>();
        // 注意："ecpm" 必须 > 0（整数），"reason" 必须 >= 0（整数）
        winInfo.put("ecpm", Math.max(1, winnerPriceCents));
        winInfo.put("reason", 102); // 102 = 败给更高出价

        mRewardedAd.notifyLoss(winInfo, (result, message, ext) -> {
            Log.d("Bidding", "notifyLoss result=" + result + ", msg=" + message);
        });

        mRewardedAd.destroy();
        mRewardedAd = null;
    }

    private int parsePositiveIntOrDefault(String val, int fallback) {
        try {
            double d = Double.parseDouble(val);
            return d > 0 ? (int) Math.round(d) : fallback;
        } catch (Exception e) {
            return fallback;
        }
    }
}
```

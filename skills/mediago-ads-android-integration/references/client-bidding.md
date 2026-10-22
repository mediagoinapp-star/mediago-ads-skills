# Client Bidding Contract and Integration Guide

Use the `IBiddingAd` contract when your app runs **in-house mediation** or needs to read the real-time bid price returned by the SDK on the client to run an auction.
*(Note: If you use the official TradPlus, TopOn, MAX, or AdMob mediation adapters, bid price reporting and win/loss notifications are handled inside the adapter automatically.)*

## 1. Core Interface and Signatures

`SplashAd`, `ExpressInterstitialAd`, `RewardedAd`, `BannerAd`, and `NativeAdLoader` all implement `cc.admaster.android.proxy.api.IBiddingAd` (`NativeAd` also provides the same methods):

```java
package cc.admaster.android.proxy.api;

public interface IBiddingAd {
    @NonNull
    ADMResponseInfo getResponseInfo();

    void notifyWin(@Nullable Map<String, Object> secondInfo, @Nullable BiddingCallback callback);

    void notifyLoss(@Nullable Map<String, Object> winInfo, @Nullable BiddingCallback callback);
}
```

Related classes and callbacks:

```java
package cc.admaster.android.proxy.api;

public final class ADMResponseInfo {
    @Nullable public String getAdUnitTag();
    @Nullable public String getResponseIdentifier();
    @Nullable public String getEcpmLevel();      // Plaintext eCPM string (in cents, e.g. "150")
    @Nullable public String getEncryptedEcpm();  // Encrypted eCPM
}

public interface BiddingCallback {
    void onBiddingResult(boolean result, @Nullable String message, @Nullable HashMap<String, Object> ext);
}
```

## 2. Strict Parameter Validation Rules

The SDK strictly validates the `Map<String, Object>` passed to `notifyWin` and `notifyLoss`. If any parameter fails validation, `BiddingCallback.onBiddingResult(false, ...)` is invoked immediately and the win/loss notice is dropped.

### 2.1 Win Notification `notifyWin(secondInfo, callback)` Parameters

Call `notifyWin` after the ad wins the auction and **before calling `show(...)`**:

| Key | Required | Format Requirement | Description |
| --- | --- | --- | --- |
| `"ecpm"` | **Required** | Positive integer or integer string (**no decimal point**, `> 0`) | Second price or winning price in **cents** (e.g. `"120"` or `120`; passing `"120.5"` or `"0"` fails validation) |
| `"min_to_win"` | Optional | Non-negative integer or integer string (`>= 0`, no decimal point) | Minimum bid to win (alias `"minimum_bid_to_win"` is also accepted) |
| `"adn"` | Optional | `Integer` / `String` | Second-price ad network identifier (e.g. `2` for third-party ADN) |

### 2.2 Loss Notification `notifyLoss(winInfo, callback)` Parameters

Call `notifyLoss` when the ad loses the auction, and **immediately call `ad.destroy()` afterward**:

| Key | Required | Format Requirement | Description |
| --- | --- | --- | --- |
| `"ecpm"` | **Required** | Positive integer or integer string (**no decimal point**, `> 0`) | Winning price from the auction winner in **cents** (if unknown, pass a fallback positive integer such as `100`) |
| `"reason"` | **Required** | Non-negative integer or integer string (**no decimal point**, `>= 0`) | Loss reason code (use standard integer codes listed below) |
| `"min_to_win"` | Optional | Non-negative integer or integer string (`>= 0`, no decimal point) | Minimum bid to win |
| `"adn"` | Optional | `Integer` / `String` | Winning ad network identifier |

Standard `"reason"` codes:
- `102`: Lost to a higher bid in Header Bidding / C2S auction (recommended default)
- `103`: Lost to a higher-priced waterfall instance
- `2`: Bidding timeout
- `5`: Ad expired before show

## 3. Standard Sequence and Code Example

### Execution Sequence

1. Call `load(...)` for the target ad format.
2. In `onAdLoaded(ad)`, read the bid price via `ad.getResponseInfo().getEcpmLevel()`.
3. Run your client auction:
   - **On Win**: Verify `!ad.isExpired()`, call `ad.notifyWin(secondInfo, callback)`, and then call `ad.show(...)`.
   - **On Loss**: Call `ad.notifyLoss(winInfo, callback)`, then immediately call `ad.destroy()` and clear the reference.

### Java Example (using `RewardedAd`)

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
                // 1. Read eCPM returned by the SDK (in cents, e.g. "180")
                String ecpmStr = ad.getResponseInfo().getEcpmLevel();
                int bidPriceCents = parsePositiveIntOrDefault(ecpmStr, 0);

                // Submit bidPriceCents to your mediation auction...
            }

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {
                // No fill or load failure; exclude from auction
            }
        });
    }

    // 2A. Win branch: report notifyWin BEFORE show()
    public void onBidWinAndShow(Activity activity, int secondPriceCents) {
        if (mRewardedAd == null || !mRewardedAd.isReady() || mRewardedAd.isExpired()) {
            return;
        }
        Map<String, Object> secondInfo = new HashMap<>();
        // Note: "ecpm" must be a positive integer (> 0) without a decimal point
        secondInfo.put("ecpm", Math.max(1, secondPriceCents));
        secondInfo.put("min_to_win", Math.max(1, secondPriceCents + 1));

        mRewardedAd.notifyWin(secondInfo, (result, message, ext) -> {
            Log.d("Bidding", "notifyWin result=" + result + ", msg=" + message);
        });

        mRewardedAd.show(activity, reward -> {
            // Grant user reward
        });
    }

    // 2B. Loss branch: report notifyLoss and destroy immediately
    public void onBidLoss(int winnerPriceCents) {
        if (mRewardedAd == null) {
            return;
        }
        Map<String, Object> winInfo = new HashMap<>();
        // Note: "ecpm" must be > 0 (integer) and "reason" must be >= 0 (integer)
        winInfo.put("ecpm", Math.max(1, winnerPriceCents));
        winInfo.put("reason", 102); // 102 = Lost to higher bid

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

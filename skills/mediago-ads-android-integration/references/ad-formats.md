# Ad Formats API Signatures and Code Templates

All ad format classes and listener interfaces reside in package `cc.admaster.android.proxy.api`.

---

## 1. Common Callback Interfaces

```java
package cc.admaster.android.proxy.api;

// Generic asynchronous load callback (used by SplashAd, ExpressInterstitialAd, RewardedAd, BannerAdLoader)
public interface AdLoadCallback<T> {
    void onAdLoaded(@NonNull T ad);
    void onAdFailedToLoad(@NonNull AdError error);
}

// Fullscreen lifecycle callback (used by SplashAd, ExpressInterstitialAd, RewardedAd)
public interface FullScreenContentCallback {
    default void onAdShowedFullScreenContent() {}
    default void onAdDismissedFullScreenContent(@NonNull AdDismissInfo dismissInfo) {}
    default void onAdFailedToShowFullScreenContent(@NonNull AdError error) {}
    default void onAdClicked() {}
    default void onAdImpression() {}
}

// Dismissal info
public final class AdDismissInfo {
    @NonNull public DismissReason getReason(); // COMPLETED, SKIPPED, CLOSE_BUTTON, BACK_KEY
    public float getPlayProgress();            // 0.0 ~ 1.0
}
```

---

## 2. Splash Ad (`SplashAd`)

### Core Method Signatures

```java
// Option 1 (Recommended): Separate load and show (supports Client Bidding or custom bottom logo area)
public static void load(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull AdLoadCallback<SplashAd> callback);

public void show(@NonNull ViewGroup container);
public void show(@NonNull ViewGroup container, @Nullable View bottomView);

// Option 2: One-step load and immediate display
public static void loadAndShow(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull ViewGroup container,
        @NonNull AdLoadCallback<SplashAd> callback);

// State & Lifecycle
public boolean isReady();
public boolean isExpired();
public void destroy();
public void setFullScreenContentCallback(@Nullable FullScreenContentCallback callback);
public void setSkipListener(@Nullable OnAdSkipListener listener);
public void setLandingPageListener(@Nullable OnLandingPageListener listener);
public void setAdCacheListener(@Nullable AdCacheListener listener);
```

### Code Template (Two-Step Load & Show)

```java
import android.content.Context;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import cc.admaster.android.proxy.api.AdDismissInfo;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdLoadCallback;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.FullScreenContentCallback;
import cc.admaster.android.proxy.api.SplashAd;

public class SplashAdHelper {
    private SplashAd mSplashAd;

    public void loadAndShowSplash(Context context, String adUnitId, ViewGroup splashContainer, Runnable onEnterMainApp) {
        AdRequest request = new AdRequest.Builder()
                .setTimeout(5000)
                .addExtra(SplashAd.KEY_IMMERSIVE, "true") // Optional: immersive splash mode
                .build();

        SplashAd.load(context, adUnitId, request, new AdLoadCallback<SplashAd>() {
            @Override
            public void onAdLoaded(@NonNull SplashAd ad) {
                mSplashAd = ad;
                ad.setFullScreenContentCallback(new FullScreenContentCallback() {
                    @Override
                    public void onAdDismissedFullScreenContent(@NonNull AdDismissInfo dismissInfo) {
                        destroySplash();
                        onEnterMainApp.run();
                    }

                    @Override
                    public void onAdFailedToShowFullScreenContent(@NonNull AdError error) {
                        destroySplash();
                        onEnterMainApp.run();
                    }
                });

                if (ad.isReady() && !ad.isExpired()) {
                    ad.show(splashContainer);
                } else {
                    destroySplash();
                    onEnterMainApp.run();
                }
            }

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {
                onEnterMainApp.run();
            }
        });
    }

    public void destroySplash() {
        if (mSplashAd != null) {
            mSplashAd.destroy();
            mSplashAd = null;
        }
    }
}
```

---

## 3. Interstitial Ad (`ExpressInterstitialAd`)

### Core Method Signatures

```java
public static void load(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull AdLoadCallback<ExpressInterstitialAd> callback);

public boolean isReady();
public boolean isExpired();
public void show(@NonNull Activity activity);
public void destroy();
public void setFullScreenContentCallback(@Nullable FullScreenContentCallback callback);
public void setLandingPageListener(@Nullable OnLandingPageListener listener);
public void setAdCacheListener(@Nullable AdCacheListener listener);
```

### Code Template

```java
import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import cc.admaster.android.proxy.api.AdDismissInfo;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdLoadCallback;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.ExpressInterstitialAd;
import cc.admaster.android.proxy.api.FullScreenContentCallback;

public class InterstitialAdManager {
    private ExpressInterstitialAd mInterstitialAd;

    public void preload(Context context, String adUnitId) {
        AdRequest request = new AdRequest.Builder().build();
        ExpressInterstitialAd.load(context, adUnitId, request, new AdLoadCallback<ExpressInterstitialAd>() {
            @Override
            public void onAdLoaded(@NonNull ExpressInterstitialAd ad) {
                mInterstitialAd = ad;
                ad.setFullScreenContentCallback(new FullScreenContentCallback() {
                    @Override
                    public void onAdDismissedFullScreenContent(@NonNull AdDismissInfo dismissInfo) {
                        destroy();
                        // Optional: preload the next interstitial here
                    }

                    @Override
                    public void onAdFailedToShowFullScreenContent(@NonNull AdError error) {
                        destroy();
                    }
                });
            }

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {
                mInterstitialAd = null;
            }
        });
    }

    public boolean showIfReady(Activity activity) {
        if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
            return false;
        }
        if (mInterstitialAd != null && mInterstitialAd.isReady() && !mInterstitialAd.isExpired()) {
            mInterstitialAd.show(activity);
            return true;
        }
        return false;
    }

    public void destroy() {
        if (mInterstitialAd != null) {
            mInterstitialAd.destroy();
            mInterstitialAd = null;
        }
    }
}
```

---

## 4. Rewarded Video Ad (`RewardedAd`)

### Core Method Signatures

```java
public static void load(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull AdLoadCallback<RewardedAd> callback);

public boolean isReady();
public boolean isExpired();
public void show(@NonNull Activity activity, @Nullable OnUserEarnedRewardListener rewardListener);
public void destroy();
public void setFullScreenContentCallback(@Nullable FullScreenContentCallback callback);
public void setSkipListener(@Nullable OnAdSkipListener listener);
public void setLandingPageListener(@Nullable OnLandingPageListener listener);
public void setAdCacheListener(@Nullable AdCacheListener listener);
```

### Reward Callback Interface

```java
public interface OnUserEarnedRewardListener {
    void onUserEarnedReward(@NonNull RewardItem reward);
}

public final class RewardItem {
    @NonNull public String getType();
    public int getAmount();
}
```

### Code Template

```java
import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import cc.admaster.android.proxy.api.AdDismissInfo;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdLoadCallback;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.FullScreenContentCallback;
import cc.admaster.android.proxy.api.RewardItem;
import cc.admaster.android.proxy.api.RewardedAd;

public class RewardedAdManager {
    private RewardedAd mRewardedAd;

    public void preload(Context context, String adUnitId) {
        AdRequest request = new AdRequest.Builder().build();
        RewardedAd.load(context, adUnitId, request, new AdLoadCallback<RewardedAd>() {
            @Override
            public void onAdLoaded(@NonNull RewardedAd ad) {
                mRewardedAd = ad;
                ad.setFullScreenContentCallback(new FullScreenContentCallback() {
                    @Override
                    public void onAdDismissedFullScreenContent(@NonNull AdDismissInfo dismissInfo) {
                        destroy();
                    }

                    @Override
                    public void onAdFailedToShowFullScreenContent(@NonNull AdError error) {
                        destroy();
                    }
                });
            }

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {
                mRewardedAd = null;
            }
        });
    }

    public boolean showIfReady(Activity activity, Runnable onRewardEarned) {
        if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
            return false;
        }
        if (mRewardedAd != null && mRewardedAd.isReady() && !mRewardedAd.isExpired()) {
            // Never grant rewards synchronously at show() call site; only grant inside onUserEarnedReward
            mRewardedAd.show(activity, (@NonNull RewardItem reward) -> {
                if (onRewardEarned != null) {
                    onRewardEarned.run();
                }
            });
            return true;
        }
        return false;
    }

    public void destroy() {
        if (mRewardedAd != null) {
            mRewardedAd.destroy();
            mRewardedAd = null;
        }
    }
}
```

---

## 5. Banner Ad (`AdMBannerView` / `BannerAdLoader`)

The SDK provides two Banner integration patterns:
- **View Mode (`AdMBannerView`)**: Add `AdMBannerView` directly to your layout container and call `loadAd(request)`.
- **Loader Mode (`BannerAdLoader` + `BannerAd`)**: Separate loading from view attachment, ideal for Client Bidding or preloading.

### 5.1 View Mode (`AdMBannerView`)

```java
import android.content.Context;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdMBannerView;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.BannerAdListener;

public class BannerViewExample {
    private AdMBannerView mBannerView;

    public void loadBanner(Context context, String adUnitId, ViewGroup bannerContainer) {
        mBannerView = new AdMBannerView(context, adUnitId, AdMBannerView.AdSize.BANNER);
        mBannerView.setListener(new BannerAdListener() {
            @Override
            public void onAdLoaded() {}

            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {}

            @Override
            public void onAdImpression() {}

            @Override
            public void onAdClicked() {}

            @Override
            public void onAdClosed() {
                bannerContainer.removeAllViews();
            }
        });

        bannerContainer.removeAllViews();
        bannerContainer.addView(mBannerView);
        mBannerView.loadAd(new AdRequest.Builder().build());
    }

    public void destroy() {
        if (mBannerView != null) {
            mBannerView.destroy();
            mBannerView = null;
        }
    }
}
```

### 5.2 Loader Mode (`BannerAdLoader` + `BannerAd`)

```java
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdLoadCallback;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.BannerAd;
import cc.admaster.android.proxy.api.BannerAdListener;
import cc.admaster.android.proxy.api.BannerAdLoader;

BannerAdLoader.load(context, adUnitId, new AdRequest.Builder().build(), new AdLoadCallback<BannerAd>() {
    @Override
    public void onAdLoaded(@NonNull BannerAd ad) {
        ad.setBannerAdListener(new BannerAdListener() {
            @Override
            public void onAdClosed() {
                container.removeAllViews();
                ad.destroy();
            }
        });
        View bannerView = ad.getView();
        if (bannerView != null && !ad.isExpired()) {
            container.removeAllViews();
            container.addView(bannerView);
        }
    }

    @Override
    public void onAdFailedToLoad(@NonNull AdError error) {
    }
});
```

---

## 6. Native Ad (`NativeAdLoader` & `NativeAd`)

### Core Method Signatures

```java
// 1. Build NativeAdLoader
NativeAdLoader loader = new NativeAdLoader.Builder(context, adUnitId)
        .withAdLoadListener(new NativeAdLoadListener() {
            @Override
            public void onNativeAdsLoaded(@NonNull List<NativeAd> ads) {}
            @Override
            public void onAdFailedToLoad(@NonNull AdError error) {}
        })
        .withInteractionListener(new NativeAdInteractionListener() {
            @Override
            public void onAdImpression(@NonNull NativeAd ad) {}
            @Override
            public void onAdClicked(@NonNull NativeAd ad) {}
        })
        .build();

// 2. Request ads (single or batch)
loader.loadAd(request);
loader.loadAds(request, maxCount);

// 3. NativeAd asset getters & interaction registration
@NonNull public String getTitle();
@NonNull public String getDescription();
@NonNull public String getIconUrl();
@NonNull public String getImageUrl();
@NonNull public String getClickUrl();
public int getAdType();
@Nullable public View getAdView(); // Returns rendered View for Video/HTML creatives; null for pure image/text ads
public void registerViewForInteraction(
        @NonNull ViewGroup container,
        @NonNull List<View> clickableViews,
        @Nullable NativeAdInteractionListener listener);
public void destroy();
```

### Code Template

```java
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import java.util.ArrayList;
import java.util.List;
import cc.admaster.android.proxy.api.AdError;
import cc.admaster.android.proxy.api.AdRequest;
import cc.admaster.android.proxy.api.NativeAd;
import cc.admaster.android.proxy.api.NativeAdInteractionListener;
import cc.admaster.android.proxy.api.NativeAdLoadListener;
import cc.admaster.android.proxy.api.NativeAdLoader;

public class NativeAdExample {
    private NativeAdLoader mLoader;
    private NativeAd mCurrentNativeAd;

    public void loadNativeAd(
            Context context,
            String adUnitId,
            ViewGroup adContainer,
            TextView titleView,
            TextView descView,
            FrameLayout mediaContainer,
            Button ctaButton) {

        mLoader = new NativeAdLoader.Builder(context, adUnitId)
                .withAdLoadListener(new NativeAdLoadListener() {
                    @Override
                    public void onNativeAdsLoaded(@NonNull List<NativeAd> ads) {
                        if (ads.isEmpty()) {
                            return;
                        }
                        if (mCurrentNativeAd != null) {
                            mCurrentNativeAd.destroy();
                        }
                        mCurrentNativeAd = ads.get(0);
                        renderNativeAd(mCurrentNativeAd, adContainer, titleView, descView, mediaContainer, ctaButton);
                    }

                    @Override
                    public void onAdFailedToLoad(@NonNull AdError error) {
                    }
                })
                .build();

        mLoader.loadAd(new AdRequest.Builder().build());
    }

    private void renderNativeAd(
            NativeAd ad,
            ViewGroup adContainer,
            TextView titleView,
            TextView descView,
            FrameLayout mediaContainer,
            Button ctaButton) {

        titleView.setText(ad.getTitle());
        descView.setText(ad.getDescription());

        // Mount ad.getAdView() if video/HTML creative is present; otherwise load ad.getImageUrl() into an ImageView
        mediaContainer.removeAllViews();
        View mediaView = ad.getAdView();
        if (mediaView != null) {
            mediaContainer.addView(mediaView);
        }

        // You MUST call registerViewForInteraction to enable impression and click tracking
        List<View> clickableViews = new ArrayList<>();
        clickableViews.add(titleView);
        clickableViews.add(descView);
        clickableViews.add(mediaContainer);
        clickableViews.add(ctaButton);

        ad.registerViewForInteraction(adContainer, clickableViews, new NativeAdInteractionListener() {
            @Override
            public void onAdImpression(@NonNull NativeAd nativeAd) {
            }

            @Override
            public void onAdClicked(@NonNull NativeAd nativeAd) {
            }
        });
    }

    public void destroy() {
        if (mCurrentNativeAd != null) {
            mCurrentNativeAd.destroy();
            mCurrentNativeAd = null;
        }
        if (mLoader != null) {
            mLoader.destroy();
            mLoader = null;
        }
    }
}
```

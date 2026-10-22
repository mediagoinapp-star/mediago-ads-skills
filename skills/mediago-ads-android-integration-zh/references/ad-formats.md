# 五大广告格式（Ad Formats）API 签名与代码模板

所有广告格式类与回调接口均位于包 `cc.admaster.android.proxy.api` 下。

---

## 1. 通用回调接口速查

```java
package cc.admaster.android.proxy.api;

// 通用异步加载回调（用于 SplashAd / ExpressInterstitialAd / RewardedAd / BannerAdLoader）
public interface AdLoadCallback<T> {
    void onAdLoaded(@NonNull T ad);
    void onAdFailedToLoad(@NonNull AdError error);
}

// 全屏内容生命周期回调（用于 SplashAd / ExpressInterstitialAd / RewardedAd）
public interface FullScreenContentCallback {
    default void onAdShowedFullScreenContent() {}
    default void onAdDismissedFullScreenContent(@NonNull AdDismissInfo dismissInfo) {}
    default void onAdFailedToShowFullScreenContent(@NonNull AdError error) {}
    default void onAdClicked() {}
    default void onAdImpression() {}
}

// 关闭原因信息
public final class AdDismissInfo {
    @NonNull public DismissReason getReason(); // COMPLETED, SKIPPED, CLOSE_BUTTON, BACK_KEY
    public float getPlayProgress();            // 0.0 ~ 1.0
}
```

---

## 2. 开屏广告（`SplashAd`）

### 核心方法签名

```java
// 方式一（推荐）：加载与展示分离（支持在 onAdLoaded 后获取竞价信息或挂载自定义底部 Logo 区）
public static void load(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull AdLoadCallback<SplashAd> callback);

public void show(@NonNull ViewGroup container);
public void show(@NonNull ViewGroup container, @Nullable View bottomView);

// 方式二：一步加载并立即展示
public static void loadAndShow(
        @NonNull Context context,
        @NonNull String adUnitId,
        @NonNull AdRequest request,
        @NonNull ViewGroup container,
        @NonNull AdLoadCallback<SplashAd> callback);

// 状态与生命周期
public boolean isReady();
public boolean isExpired();
public void destroy();
public void setFullScreenContentCallback(@Nullable FullScreenContentCallback callback);
public void setSkipListener(@Nullable OnAdSkipListener listener);
public void setLandingPageListener(@Nullable OnLandingPageListener listener);
public void setAdCacheListener(@Nullable AdCacheListener listener);
```

### 代码模板（两步加载 + 展示）

```java
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
                .addExtra(SplashAd.KEY_IMMERSIVE, "true") // 可选：沉浸式开屏
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

## 3. 插屏广告（`ExpressInterstitialAd`）

### 核心方法签名

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

### 代码模板

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
                        // 可选：关闭后预加载下一条
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

## 4. 激励视频广告（`RewardedAd`）

### 核心方法签名

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

### 奖励回调接口

```java
public interface OnUserEarnedRewardListener {
    void onUserEarnedReward(@NonNull RewardItem reward);
}

public final class RewardItem {
    @NonNull public String getType();
    public int getAmount();
}
```

### 代码模板

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
            // 严禁在 show() 调用点直接发奖，必须在 onUserEarnedReward 回调中发放奖励
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

## 5. 横幅广告（`AdMBannerView` / `BannerAdLoader`）

SDK 提供两种 Banner 接入方式：
- **视图模式（`AdMBannerView`）**：直接作为 `FrameLayout` 子类挂载到布局容器并调用 `loadAd(request)`。
- **加载器模式（`BannerAdLoader` + `BannerAd`）**：加载与视图分离，适合需要在挂载前进行 Client Bidding 比价或预加载的场景。

### 5.1 视图模式（`AdMBannerView`）

```java
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

### 5.2 加载器模式（`BannerAdLoader` + `BannerAd`）

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

## 6. 原生自渲染/信息流广告（`NativeAdLoader` & `NativeAd`）

### 核心方法签名

```java
// 1. 构建加载器
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

// 2. 发起请求（单条或多条）
loader.loadAd(request);
loader.loadAds(request, maxCount);

// 3. NativeAd 素材读取与交互注册
@NonNull public String getTitle();
@NonNull public String getDescription();
@NonNull public String getIconUrl();
@NonNull public String getImageUrl();
@NonNull public String getClickUrl();
public int getAdType();
@Nullable public View getAdView(); // 视频或 HTML 模板素材返回渲染 View，纯图文素材返回 null
public void registerViewForInteraction(
        @NonNull ViewGroup container,
        @NonNull List<View> clickableViews,
        @Nullable NativeAdInteractionListener listener);
public void destroy();
```

### 代码模板

```java
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
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

        // 若包含视频或 HTML 媒体视图，挂载 getAdView()；否则可使用 Glide/Picasso 加载 ad.getImageUrl()
        mediaContainer.removeAllViews();
        View mediaView = ad.getAdView();
        if (mediaView != null) {
            mediaContainer.addView(mediaView);
        }

        // 必须调用 registerViewForInteraction 绑定可点击控件，否则点击和曝光不会生效！
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

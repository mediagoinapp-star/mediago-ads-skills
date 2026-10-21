# Ad formats

Read the selected section before generating code. Use the customer's real placement ID; use test credentials only in an explicitly requested test flow.

## Splash

`SplashAd` supports a load-then-show flow and a documented convenience load-and-show flow. A splash show requires a `ViewGroup` container. Handle load failure and full-screen dismissal by continuing the host startup flow. Destroy the ad when no longer needed.

## Interstitial

Load `ExpressInterstitialAd`, retain it after a successful load, and call `show(Activity)` only when it is ready and the Activity is valid. Clear/destroy the retained reference after dismissal or a show failure, then allow the app to continue.

## Rewarded

Load `RewardedAd`, show it only from a valid Activity when ready, and award the business reward only in `OnUserEarnedRewardListener`. Do not infer a reward from an impression, click, or dismissal. Clear/destroy after dismissal or show failure.

## Banner

Create the documented banner object/container, bind it to the screen lifecycle, and explicitly destroy it when its host view is permanently removed. Check width/height/container requirements before diagnosing a blank banner.

## Native

Use `NativeAdLoader` to load. Render only supported asset values, then register the root view and allowed clickable views using the native interaction API. Do not make disclosure, dislike, media, or non-clickable views clickable unless the documented API permits it. Destroy loaded native objects when their item or screen is disposed.

## Shared callbacks

For full-screen formats, install callbacks before show. At minimum handle shown, impression, click, dismissed, and failed-to-show. Landing-page callbacks are separate when supported. Every terminal callback needs an app-flow fallback and reference cleanup.

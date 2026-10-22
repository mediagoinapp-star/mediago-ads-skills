#!/usr/bin/env bash
# Read-only project inventory for a MediaGo Android integration review.
set -euo pipefail
project_root="${1:-.}"
cd "$project_root"
printf 'Project root: %s\n' "$PWD"

EXCLUDE_DIRS=(--exclude-dir=.git --exclude-dir=.gradle --exclude-dir=build --exclude-dir=.idea)

printf '\n== Gradle settings ==\n'
find . -maxdepth 2 -type f \( -name 'settings.gradle' -o -name 'settings.gradle.kts' \) -print

printf '\n== Android application modules ==\n'
grep -RIl "${EXCLUDE_DIRS[@]}" --include='*.gradle' --include='*.gradle.kts' \
  -E 'com\.android\.application|libs\.plugins\.android[._-]?[aA]pplication' . 2>/dev/null || true

printf '\n== MediaGo & Mediation dependencies ==\n'
grep -RIn "${EXCLUDE_DIRS[@]}" --include='*.gradle' --include='*.gradle.kts' --include='libs.versions.toml' \
  -E 'cc\.admaster\.android|mediago|(max|tradplus|topon(-secmtp)?)-adapter|com\.(thinkup|anythink)\.sdk:core-tpn|play-services-ads|applovin-sdk' . 2>/dev/null || true

printf '\n== Relevant manifests ==\n'
find . -path '*/build/*' -prune -o -path '*/.gradle/*' -prune -o -path '*/src/main/AndroidManifest.xml' -type f -print

printf '\n== Java/Kotlin MediaGo API references ==\n'
grep -RIn "${EXCLUDE_DIRS[@]}" --include='*.java' --include='*.kt' \
  -E 'AdMaster\.initialize|AdMasterSetting|SplashAd|ExpressInterstitialAd|RewardedAd|NativeAdLoader|BannerAdLoader|AdMBannerView|AdActivityController|IBiddingAd|notifyWin|notifyLoss' . 2>/dev/null || true

#!/usr/bin/env bash
# Read-only project inventory for a MediaGo Android integration review.
set -euo pipefail
project_root="${1:-.}"
cd "$project_root"
printf 'Project root: %s\n' "$PWD"
printf '\n== Gradle settings ==\n'
find . -maxdepth 2 -type f \( -name 'settings.gradle' -o -name 'settings.gradle.kts' \) -print
printf '\n== Android application modules ==\n'
grep -RIl --include='*.gradle' --include='*.gradle.kts' 'com.android.application' . 2>/dev/null || true
printf '\n== MediaGo dependencies/references ==\n'
grep -RIn --include='*.gradle' --include='*.gradle.kts' --include='libs.versions.toml' -E 'cc\.admaster\.android|mediago|adapter-(admob|max)|tradplus-adapter|topon(-secmtp)?-adapter' . 2>/dev/null || true
printf '\n== Relevant manifests ==\n'
find . -path '*/src/main/AndroidManifest.xml' -type f -print
printf '\n== Java/Kotlin initialization references ==\n'
grep -RIn --include='*.java' --include='*.kt' -E 'AdMaster\.initialize|AdMasterSetting|SplashAd|ExpressInterstitialAd|RewardedAd|NativeAdLoader|BannerAd' . 2>/dev/null || true

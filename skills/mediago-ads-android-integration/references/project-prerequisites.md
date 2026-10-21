# Project prerequisites

## Baseline

The current supported Android baseline is `minSdk 21` and `compileSdk 34` or newer. Report a lower value as a prerequisite issue; do not silently change it.

MediaGo artifacts are published to Maven Central. Confirm `mavenCentral()` in the repository configuration actually used by the build:

- Gradle 7+: normally `dependencyResolutionManagement.repositories` in `settings.gradle(.kts)`.
- Older projects: normally `allprojects.repositories` in the root build file.

Do not add duplicate repository blocks without checking which model the project uses.

## Direct SDK dependency

Use the SDK coordinate documented for the customer's supported release, normally:

```gradle
implementation "cc.admaster.android:sdk:<approved-version>"
```

Prefer an approved fixed version for customer releases. Do not silently add a dynamic `+` dependency to a production project; explain the trade-off and follow the customer's version policy.

## Permissions and manifest

Network permission is declared by the SDK. On Android 13+ the `com.google.android.gms.permission.AD_ID` permission is optional and is relevant only if the customer needs Advertising ID. Do not add location, storage, phone-state, installation, or other sensitive permissions just because older sample projects declare them.

Inspect merged-manifest inputs before proposing MediaGo Activities, providers, or process overrides. Preserve application-specific manifest placeholders and avoid duplicate authority declarations.

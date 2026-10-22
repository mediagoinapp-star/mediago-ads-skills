# 官方测试参数与联调验证规范（Test Credentials）

在首次接入联调或遇到正式广告位因预算/定向原因返回无填充（`2000` / `1040004`）时，可使用以下来自官方 Demo（`AdConfigManager`）的测试 `appId` 与各广告格式测试 `adUnitId`，快速验证客户端加载、展示与回调全链路。

---

## 1. 官方测试 App ID 与广告位 ID（Android）

| 参数类型 | 对应 API 类 | 官方测试值（`String`） | 格式校验规则 |
| --- | --- | --- | --- |
| **测试 App ID (`appsid`)** | `AdMaster.initialize(...)` | `ad2fd73dca2ccffd312495bcd8a33d29` | 32 位小写十六进制字符串（`^[a-f0-9]{32}$`） |
| **激励视频 (`Rewarded`)** | `RewardedAd` | `100090001` | 纯数字字符串（严禁转 `int` 丢失前导零） |
| **插屏 (`Interstitial`)** | `ExpressInterstitialAd` | `100090002` | 纯数字字符串 |
| **原生自渲染 (`Native`)** | `NativeAdLoader` / `NativeAd` | `100090003` | 纯数字字符串 |
| **开屏 (`Splash`)** | `SplashAd` | `100090004` | 纯数字字符串 |
| **横幅 (`Banner`)** | `AdMBannerView` / `BannerAdLoader` | `100090005` | 纯数字字符串 |

---

## 2. 调试日志开启方式

在 Debug 联调阶段，建议开启 SDK 调试日志以便在 Logcat 中观察请求、缓存与回调状态：

```java
import cc.admaster.android.proxy.api.AdMasterSetting;

if (BuildConfig.DEBUG) {
    AdMasterSetting.getInstance().setDebugLogEnable(true);
}
```

---

## 3. 测试参数使用红线（硬门禁）

1. **严禁将测试 ID 带入正式发版包**：测试 `appId`（`ad2fd73dca2ccffd312495bcd8a33d29`）与测试广告位（`100090001` ~ `100090005`）仅用于本地开发与集成验收，不产生任何变现收益。
2. **禁止覆盖用户已提供的正式参数**：如果宿主工程中已配置正式 `appId` / `adUnitId`，仅在需要对比排查“代码问题还是线上无填充”时通过 `BuildConfig.DEBUG` 分支或临时测试配置使用测试参数，验证完毕后立即恢复正式参数。
3. **保留字符串类型**：所有 `adUnitId`（包括含前导零的正式广告位 ID，如 `"057362412"`）必须全程作为 `String` 存储和传递，严禁使用 `Integer.parseInt` 数值化。

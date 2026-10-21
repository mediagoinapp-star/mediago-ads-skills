# 聚合 Adapter

修改依赖前，先检查已安装的聚合 SDK 和版本。说明目标 Adapter 与配置路径后，再请求用户确认修改 Gradle 或代码。

## AdMob

使用与客户 Google Mobile Ads SDK 和 MediaGo SDK 兼容的 MediaGo AdMob Adapter。MediaGo 额外参数通过 AdMob network extras 传递。Adapter 负责聚合接入生命周期；不要自动增加第二条 SDK 直连广告请求路径。

## AppLovin MAX

使用与客户 MAX SDK 兼容的 MediaGo MAX Adapter。样式特定参数通过 MAX local extra parameter 机制传入，广告生命周期与回调遵循 MAX API。

## TradPlus

使用 MediaGo TradPlus Adapter，并在 TradPlus 后台为各广告样式配置文档规定的 MediaGo Adapter 类。MediaGo App ID 与广告位 ID 属于 Adapter 凭证，不等于 TradPlus 广告位 ID。保留客户现有的 TradPlus 初始化与回调。

## TopOn

必须先识别 TopOn SDK 类型后再选择 Adapter：

- 国际版：`com.thinkup.sdk:core-tpn`，使用 MediaGo TopOn Adapter；
- 旧版：`com.anythink.sdk:core-tpn`，使用 MediaGo TopOn 旧版/SecMTP Adapter。

在相应 TopOn 后台配置各广告样式的 Adapter 类和 MediaGo App/Placement 凭证。不得凭记忆填写 Adapter 类名；公开发布或修改接入前，必须用带版本的 MediaGo 对外 Adapter 文档核验。

## 通用检查

- 避免重复引入基础 SDK 或 Adapter；
- 通过已批准兼容矩阵对齐 MediaGo 和 Adapter 版本；
- Adapter 流程中不得因习惯而额外调用直连 `AdMaster.initialize`；
- 保留聚合平台对回调、隐私、竞价和后台配置的要求；
- 改动依赖后应构建，并检查依赖解析冲突。

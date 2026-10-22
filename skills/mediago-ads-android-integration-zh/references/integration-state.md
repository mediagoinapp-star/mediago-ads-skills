# 接入状态与硬门禁

在客户工程或已批准的版本化资料中得到验证前，所有事实均视为**未知**。

## 状态记录

工作过程中维护以下简表：

```text
工程：Android App 模块 / 语言 / Gradle DSL
路径：direct | client-bidding | admob | max | tradplus | topon-international | topon-legacy
SDK：声明版本 / 已解析版本 / 已批准版本
Adapter：声明版本 / 已解析版本 / 已批准版本
初始化：缺失 | 已发现未验证 | 已验证
凭证：缺失 | 仅测试 | 客户提供
验证：已规划 | 已应用变更 | 构建通过 | 真机已验证
```

不得将“Gradle 声明了依赖”视为“依赖已解析”，也不得因搜索到 `AdMaster.initialize` 就认定初始化成功。

## 硬门禁

### 门禁 A：支持的工程

确认存在 Android 应用模块后才能继续。若是纯 Unity 工程，停止并遵循 Router 的不支持边界。

### 门禁 B：选定接入路径

生成代码前必须确认一种路径：SDK 直连、Client Bidding、AdMob、MAX、TradPlus、TopOn 国际版或 TopOn 旧版。除非存在已批准且有文档的例外，不得在同一广告流量路径混用直连与 Adapter 生命周期。Client Bidding 是应用负责竞价与回传的直连加载变体，不是 Adapter 路径；不能仅因应用其他位置使用聚合 SDK 就选择该路径。

### 门禁 C：依赖已解析

编写 MediaGo API 代码前，确认目标 App Variant 实际解析到对应 SDK/Adapter。优先依据已批准的 Gradle dependency report 或构建结果；读取 Gradle 声明仅是初步信号。

若需要执行 Gradle 命令验证，先展示准确命令并请求用户确认。

### 门禁 D：初始化

直连和 Client Bidding 场景需验证只有一条应用级初始化路径，且首个广告加载发生在初始化成功后。Adapter 场景应以其文档定义的初始化归属为准，默认不增加直连初始化。

### 门禁 E：变更确认

A-D 门禁完成后，展示文件改动和验证命令。确认必须绑定包含文件、命令、依赖/版本变更、Manifest 影响及外发数据的计划标识和摘要。获得用户明确确认前，不得编辑、构建或解析依赖；任何新增文件、命令、依赖/版本、权限或外发数据都会使原确认失效，必须重新给出计划并确认。

## 停止条件

出现以下情况时停止并说明缺少的证据：Android 模块不明确；Adapter 类型有歧义；没有已批准的兼容性条目；客户未批准必要的编辑/构建；或请求平台不受支持。

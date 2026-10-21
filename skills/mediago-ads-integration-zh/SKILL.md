---
name: mediago-ads-integration-zh
description: 识别客户工程类型，并将 MediaGo Ads SDK 的接入、升级、排障或验证请求路由至受支持的平台流程。适用于客户未明确说明应用框架或工程类型不清晰的场景。
---

# MediaGo Ads 接入路由（中文）

本 Skill 只负责识别客户工程并选择受支持的工作流。不要在此 Skill 中生成 MediaGo SDK 调用代码、修改文件或实际执行接入。

## 先检查，后提问

在项目根目录只读检查目录和文件结构：

- **Android 原生工程：** `settings.gradle`、`settings.gradle.kts`、Android 应用模块或 `AndroidManifest.xml`。
- **Unity 工程：** 同时存在 `Assets/` 和 `ProjectSettings/`。
- **混合工程：** 同时包含 Unity 标志和独立 Android 原生模块。

遇到混合工程或无法可靠识别时，读取[平台路由规则](references/platform-routing.md)。

## 路由规则

- 仅 Android 原生工程：加载并遵循 `mediago-ads-android-integration-zh`。
- 仅 Unity 工程：明确说明 MediaGo 当前未提供官方 Unity SDK。不得建议直接嵌入 Android AAR、编造 C# API 或声称支持 Unity 接入。
- Unity 与原生 Android 混合工程：询问客户要接入哪个模块；只有客户选择独立 Android 模块后，才路由至 Android Skill。
- 无法识别：只问一个简洁问题：“你的工程是 Android 原生、Unity，还是包含独立 Android 原生模块的混合工程？”

路由时说明已选流程并保留用户的原始目标。Android Skill 会在任何修改或构建前检查工程并征得用户确认。

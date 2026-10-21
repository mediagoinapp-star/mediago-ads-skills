# MediaGo SDK 接入 Skill 与 MCP 对外发布方案

**状态：待评审**  
**范围：Android 原生 SDK；Unity 当前仅识别并说明不支持。**

## 1. 目标

让客户在 AI IDE 中完成 MediaGo Android SDK 接入、升级和排障，并保证：

- 接入结论以客户工程和官方资料为准；
- 修改工程和运行构建前必须获得客户确认；
- SDK/Adapter 版本、错误码和接入规则可追溯、可更新；
- 基础接入不依赖 MCP；MCP 不可用时仍可使用 Skill；
- 不要求客户提供生产密钥，不上传源码或完整日志。

## 2. 参考结论

### LevelPlay Skill

采用“工作流 Skill”模式：先检查真实工程；设置安装/依赖/初始化硬门禁；主流程留在 `SKILL.md`，细节按需放在 `references/`；支持迁移、版本差异、测试和排障；以构建和真机证据确认结果。

### TRTC MCP

采用“官方知识与动态服务”模式：本地 `npx` 启动 MCP Server，内置官方文档、FAQ、API、错误码、最佳实践和检索索引；按产品/平台/框架路由；区分咨询检索与明确代码集成；通过 query ID、反馈和遥测持续评估效果。少量动态能力才使用客户本地配置的密钥。

## 3. 产品架构

| 层 | 对外组件 | 职责 |
|---|---|---|
| 路由层 | `mediago-ads-integration` / `-zh` | 识别 Android、Unity、混合工程，路由到受支持流程。 |
| 实施层 | `mediago-ads-android-integration` / `-zh` | 扫描工程、输出变更计划、经确认后实施接入并验证。 |
| 知识服务层 | `@mediago/sdk-mcp`（规划） | 提供版本兼容、官方知识检索和受控诊断。 |
| 维护层 | Git 仓库 + Skill 平台 + npm | 管理源码、版本、发布说明、审核资料与安装入口。 |

**协作原则：** Skill 管工程流程和确认门禁；MCP 管权威知识、实时版本、兼容性与诊断。MCP 不直接绕过 Skill 修改工程。

## 4. Skill 发布方案

### 4.1 已有 Skill

```text
mediago-ads-integration
mediago-ads-android-integration
mediago-ads-integration-zh
mediago-ads-android-integration-zh
```

- Router：Android 原生工程路由至 Android Skill；Unity 工程明确提示当前无官方 Unity SDK；混合工程先询问目标模块。
- Android Skill：支持 Java/Kotlin、SDK 直连、开屏/Banner/插屏/激励/Native、AdMob/MAX/TradPlus/TopOn 国际版/TopOn 旧版、多进程、隐私技术设置、构建与问题排查。

### 4.2 强制工作流

```text
只读扫描工程
→ 识别接入路径和版本
→ 查询必要的官方事实/兼容性
→ 展示文件改动和构建计划
→ 用户明确确认
→ 修改工程/运行已批准命令
→ 构建与真机验证
→ 按证据报告结果
```

结果只可分为：**已规划、已应用变更、构建通过、真机已验证**。

### 4.3 发布前必须补齐

1. 将审核后的 Android 对外文档拆入 `references/`：依赖、初始化、五类广告、Adapter、Manifest、多进程、隐私、错误码、测试与迁移。
2. 确认 Maven 版本策略：固定版本、动态 `+`，或开发/生产分级；Skill 与官方文档必须一致。
3. 补充真实兼容矩阵：SDK、各 Adapter、AGP、Gradle、JDK、`minSdk`、`compileSdk`、验证日期。
4. 补充升级/迁移指南和回归清单。
5. 完善 README：安装方式、支持范围、典型提示词、Unity 边界、安全说明、FAQ、支持渠道。
6. 建立中英文内容同步检查，避免两个语言版本规则漂移。

## 5. MCP 发布方案

### 5.1 形态

独立发布 npm 包：

```text
@mediago/sdk-mcp
```

以本地 stdio MCP Server 方式运行；首次发布建议固定版本号，不默认推荐 `@latest`。

### 5.2 P0：只读 MCP Beta

| 工具 | 用途 | 输入 | 输出 |
|---|---|---|---|
| `search_mediago_knowledge` | FAQ、错误码、API、隐私、Adapter、排障 | 原始问题、平台、路径、广告样式、版本 | 对外官方答案与来源。 |
| `get_android_integration_guide` | 客户明确要求实施接入 | Java/Kotlin、直连/Adapter、广告样式、版本 | 已审核的完整实施资料。 |
| `get_sdk_compatibility` | 查询版本组合 | SDK/Adapter/AGP/Gradle/JDK/compileSdk | 兼容结果、限制、升级建议。 |

P0 不提供生产凭证、客户后台写操作、源码上传、完整日志上传或自动改代码。

### 5.3 P1：受控诊断与测试

在鉴权、审计和数据策略完成后再增加：

- `diagnose_request`：客户明确授权后，发送最小化、脱敏的诊断上下文；
- `get_test_configuration`：返回隔离的测试配置或测试资格状态。

### 5.4 P2：后台写操作

仅在必要时增加测试资源创建/更新能力。每次必须具备：最小权限、测试环境隔离、变更摘要、二次确认、审计日志、限流、可撤销或明确回执。

**禁止照搬 TRTC 的生产密钥配置模式。** MediaGo 不应要求客户将生产后台密钥放入 MCP 配置；动态能力应使用短期令牌、OAuth/API Token 或服务端受控授权。

## 6. 知识库与版本治理

MCP 和 Skill 共用同一份审核后的公开事实源：

```text
官方公开文档
→ 清洗/审核
→ 加元数据
→ Skill references + MCP 检索索引
→ 版本兼容矩阵
→ 发布与评测
```

每条知识至少标注：

```text
platform
language
integration_mode
adapter_type
ad_format
sdk_version_range
doc_type
source_version
last_verified_at
```

内部 Ku 仅用于维护，不作为外部客户运行时依赖，也不出现在公开 Skill/MCP 中。

## 7. 验证与评测

### Skill 评测

准备脱敏 fixture 或内部测试工程：

```text
Java 直连、Kotlin 直连、AdMob、MAX、TradPlus、TopOn 国际版、TopOn 旧版、
缺少 Maven Central、重复初始化、TopOn 类型错误、Manifest/多进程错误。
```

检查：路径识别是否正确、是否先扫描、是否在变更/构建前等待确认、生成代码是否与版本匹配、构建/Manifest 合并是否通过、Unity 工程是否被正确拒绝。

### MCP 评测

建立带标准答案和来源的查询集，覆盖：API、错误码、版本兼容、Adapter 区分、隐私、多进程、迁移和完整接入。度量：命中正确率、来源正确率、版本正确率、无关内容率和客户“已解决”反馈率。

## 8. 安全、隐私与反馈

- 不提交客户 App ID、广告位、密钥、源码、完整日志或内部链接；
- 日志诊断仅上传字段白名单内、自动脱敏且经客户确认的数据；
- 明确披露遥测字段、用途、保留时间和退出方式；
- 反馈可关联 `query_id`、Skill/MCP 版本、SDK/Adapter 类型和结果状态；
- “已解决/未解决”反馈应可选，不强制打断客户工作流；
- 技术指导不替代客户的隐私、法律和应用商店合规责任。

## 9. 发布节奏与验收

### 阶段 1：Skill Beta

完成第 4.3 节、fixture 前向测试和中英文一致性检查后，发布 Git Tag：

```text
v0.1.0-beta
```

同步发布至 Skill 平台。

### 阶段 2：只读 MCP Beta

完成公开知识库、元数据、检索评测和隐私说明后，发布：

```text
@mediago/sdk-mcp@0.1.0-beta
```

Skill 可调用 MCP 查询实时事实，但不能依赖 MCP 才能完成基础接入。

### 阶段 3：受控服务能力

鉴权、短期凭证、审计、脱敏、限流、测试环境隔离达标后，逐步开放诊断和测试配置能力。

## 10. 本轮评审需确认

1. Maven 版本策略：固定、动态，或开发/生产分级？
2. 兼容矩阵和对外文档的维护负责人是谁？SDK 发版是否作为更新门禁？
3. 对外 Skill 的许可证、支持渠道和 Issue 策略？
4. MCP 知识库是否允许以 npm 包内置索引方式发布？
5. 是否接受 P0 MCP 仅做只读检索/兼容性，后台测试和诊断能力后置？
6. fixture/eval 是否可建立内部仓库，作为发布门禁？

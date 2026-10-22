# 阶段 A：无 MCP 的 Skill 发布实施方案

## 目标

阶段 A 交付一个可独立安装和使用的 Android SDK 接入 Skill。它依赖仓库内经过审核的 references 与结构化兼容数据，不依赖 MCP Server、网络诊断或远程知识服务。

阶段 A 的核心路径是：

```text
客户请求 → Router → Android 只读检查 → 选定唯一接入路径
→ 本地审核知识核验 → 文件级计划 → 明确确认 → 最小实施/验证 → 证据等级报告
```

## 已完成的基础改造

- Android Skill 的中英文版本已将 Client Bidding 纳入支持范围和路径选择。
- 新增中英文 Client Bidding reference，约束过期检查、`notifyWin`、`notifyLoss`、`destroy()`、reason `102` 和竞价数据保护。
- 直连 reference 已使用公开文档确认的 `1030003` / `ERROR_NOT_INITIALIZED`，不再使用未经确认的错误码。
- 中英文硬门禁均要求计划覆盖文件、命令、依赖/版本、权限与外发数据；范围变化须重新确认。
- compatibility 文件已填充 `android-stable-2026q4`（SDK `2.4.0` 直连及五大聚合 Adapter `release_verified` 支持窗口）；超出支持窗口的版本组合仍不得在无证据时推荐为生产兼容。
- 中英文 Android references 已补齐源码核验的包名（`cc.admaster.android.proxy.api.*`）、API 签名、回调契约、Adapter 坐标与自定义类名、多进程配置、隐私合规 API、完整错误码表及官方测试参数。

## 仍需由 SDK Release Owner 提供的事实

以下数据不能从通用知识、样例工程或记忆中推断，且当前仓库没有可发布的审核条目：

1. 每个对外 SDK release 的固定 Maven 版本；
2. SDK 与各 Adapter 的已验证组合；
3. 对应的 AGP、Gradle、JDK 支持窗口；
4. 各 release 的 API / Adapter class 适用范围；
5. 可公开的错误码目录、测试策略和来源版本；
6. 每个条目的 reviewer、验证日期及外部可访问来源。

未提供这些事实前，Skill 能说明流程、检查客户工程、生成受限计划和报告缺口；不得将任何具体组合称为生产兼容。

## 支持窗口录入规范

Release Owner 提交一个最小、经过验证的窗口，而不是试图一次填满全部 SDK 和工具链组合：

```json
{
  "id": "android-stable-YYYYqN",
  "status": "release_verified",
  "sdk": "<approved-fixed-version>",
  "android": {
    "minSdk": 21,
    "compileSdkMin": 34,
    "agpRange": ">=<verified-min> <<verified-max>",
    "gradleRange": ">=<verified-min> <<verified-max>",
    "jdk": "<verified-jdk>"
  },
  "paths": [
    "direct:interstitial",
    "admob:interstitial",
    "client_bidding:rewarded"
  ],
  "source": {
    "publicUrl": "https://<public-doc>",
    "snapshotSha256": "<sha256>"
  },
  "review": {
    "reviewedBy": "<release-owner>",
    "reviewedAt": "YYYY-MM-DD"
  }
}
```

只有 `status: release_verified` 的窗口可作为生产建议。其它状态仅允许用于文档解释、迁移提示或明确标注的实验性路径。

## 阶段 A 发布门禁

### 内容门禁

- 中英文 Skill 的路径、确认规则和安全边界一致；
- Client Bidding 不与 Adapter 路径混用；
- 所有版本化事实有可发布来源和适用范围；
- 无生产或测试 App ID、广告位 ID、令牌、内部 URL、内部文档快照；
- 兼容窗口至少覆盖本次 Beta 承诺的一个直连场景、一个 Adapter 场景和一个 Client Bidding 场景。

### 行为门禁

- 没有用户确认时，Skill 不编辑文件、不运行 Gradle；
- 用户拒绝计划后，不通过“只读检查”间接执行依赖解析；
- 路径或版本不确定时，不生成版本特定代码；
- 新的文件、命令、依赖/权限或外发数据使既有确认失效；
- 未知错误码请求 SDK 版本、接入路径、广告样式和脱敏错误文本，而不猜测含义。

### 评测门禁

按 [`evals/phase-a-scenarios.md`](../evals/phase-a-scenarios.md) 对 Router、直连、Adapter、Client Bidding、迁移、确认拒绝、未知错误码与双语规则进行人工或自动评测。所有 P0 场景通过后才发布 Beta。

## 发布后的维护

每次 SDK / Adapter 发版必须同步更新：

1. compatibility support window；
2. 受影响的 references；
3. 中英文 Skill；
4. 对应 fixture / eval；
5. `README.md` 中的支持范围和 changelog。

MCP 的 Go / No-Go 决策推迟至阶段 A 真实使用后。仅当版本更新频繁、至少三个 Agent/IDE 需共享知识、或结构化查询成为支持瓶颈时，才将同一份本地结构化知识封装为只读 MCP。

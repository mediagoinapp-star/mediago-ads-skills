# 常见错误码与排障手册（Troubleshooting）

## 1. 客户端 SDK 错误码速查表（`AdError` 7 位错误码）

以下错误码定义在 `cc.admaster.android.proxy.api.AdError` 中，通过 `error.getCode()` 与 `error.getMessage()` 获取：

| 错误码 (`int`) | 常量名 | 含义说明 | 根因定位与修复建议 |
| --- | --- | --- | --- |
| `1010001` | `ERROR_INTERFACE` | 接口调用异常 | 检查调用参数（如 `adUnitId` 是否为空）或 SDK 内部桥接状态 |
| `1020001` | `ERROR_NETWORK` | 网络连接异常 | 检查设备网络连通性、代理抓包证书配置及 `INTERNET` 权限 |
| `1030001` | `ERROR_UNREGISTER_ACTIVITY` | 广告 Activity 未注册 | 检查 `AndroidManifest.xml` 是否误移除了 `MobRewardVideoActivity` / `AppActivity` 或自定义 Activity 未注册 |
| `1030002` | `ERROR_UNREGISTER_PROVIDER` | Provider 未注册 | 检查宿主 Manifest 合并规则是否排除了 SDK 组件 |
| **`1030003`** | **`ERROR_NOT_INITIALIZED`** | **SDK 尚未初始化** | **高频错误**：在 `AdMaster.initialize(...)` 的 `onInitialized()` 回调完成前调用了 `load(...)`；或者在未初始化的子进程中发起了广告请求 |
| `1040001` | `ERROR_TIMEOUT` | 广告请求超时 | 开屏或常规广告在限定时间内未返回，检查网络延迟或适当调大 `AdRequest.Builder().setTimeout(ms)` |
| `1040002` | `ERROR_REQUEST_PARAM` | 请求参数错误 | 检查 `appId`（应为 32 位十六进制字符串）与 `adUnitId`（纯数字字符串）是否匹配且来自同一后台账号 |
| `1040003` | `ERROR_REQUEST_EXCESSIVE` | 请求过于频繁 | 检查是否在失败回调 `onAdFailedToLoad` 中写了无延迟死循环重试，请改为退避重试或按展示时机触发 |
| `1040004` | `ERROR_NO_AD` | 客户端判定无广告返回 | 当前请求无填充（No Fill），联调期可切换至官方测试 `appId` + 测试 `adUnitId` 验证代码链路 |
| **`1040005`** | **`ERROR_ALREADY_LOADING`** | **同一广告位正在加载中** | **高频错误**：同一 `(adFormat, adUnitId)` 上一次请求尚未回调完成就重复调用了 `load(...)`，请避免并发重复请求 |
| **`1040006`** | **`ERROR_AD_EXPIRED`** | **广告已过期** | 缓存的广告已超过有效期，展示前必须检查 `!ad.isExpired()`；若已过期请调用 `ad.destroy()` 并重新加载 |
| `3010001` | `ERROR_PARSE` | 响应解析失败 | 服务端返回数据格式异常或被网络代理篡改 |
| **`3010002`** | **`ERROR_MATERIAL_EMPTY`** | **返回广告物料为空** | 广告响应无可用素材（视为 No Fill） |
| `3020001` | `ERROR_FILTER_APP` | 广告因应用条件被过滤 | 目标安装包已存在或不符合投放定向 |
| `3020002` | `ERROR_FILTER_SIZE` | 容器尺寸不满足要求 | 开屏或 Banner 容器宽高过小或未完成布局测量，确保容器可见且宽高有效 |
| `3030001` | `ERROR_CACHE_NOT_COMPLETED` | 视频/素材缓存未完成 | 尝试在素材就绪前展示 |
| **`3030002`** | **`ERROR_CACHE_FAILED`** | **素材缓存下载失败** | 广告视频或图片资源下载失败，检查外网 CDN 连通性 |
| **`3040001`** | **`ERROR_DISPLAY_STANDARD_UNFIT`** | **展示条件不满足** | 传入的 `Activity` 已处于 `isFinishing()` / `isDestroyed()`，或容器 `ViewGroup` 不可见 |
| **`3040002`** | **`ERROR_DISPLAY_FAILED`** | **广告展示失败** | 广告未就绪（`!ad.isReady()`）、已展示过、或已销毁后再次调用 `show(...)` |
| `3040003` | `ERROR_RENDER_FAILED` | 模板/视图渲染失败 | WebView 或原生模板渲染异常 |
| **`3040004`** | **`ERROR_SPLASH_CONTAINER_INVISIBLE`** | **开屏容器不可见** | 调用 `SplashAd.show(container)` 时，`container` 未挂载到窗口、`visibility != VISIBLE` 或宽高为 0 |
| `4030007` | `ERROR_AD_DISMISS_CLOSED` | 广告在加载/准备期间被关闭 | 用户或宿主在展示完成前提前关闭了容器 |

---

## 2. 服务端错误码速查表（4 位错误码）

当服务端返回非 0 状态码时，`AdError.getCode()` 会透传 4 位服务端状态码：

| 错误码范围 | 分类 | 常见原因与排查方法 |
| --- | --- | --- |
| **`2000`** | **DSP 无填充 (No Fill)** | 广告请求链路已通，但当前预算/定向下无匹配的广告返回。**联调验证代码是否正常时，请改用 `references/test-credentials.md` 中的官方测试 ID** |
| **`3000 ~ 3004`** | **ADX 策略过滤 (No Fill)** | 频次控制、底价过滤（`bidFloor` 设置过高）或地区/设备定向过滤 |
| **`4000 ~ 4004`** | **请求参数校验失败 (Bad Request)** | `appId` 或 `adUnitId` 不存在、状态未开启、或广告位类型（如拿激励视频 ID 去调插屏接口）不匹配 |
| **`1000 ~ 1999`** | **服务端内部异常** | 服务端临时错误，记录请求日志并稍后重试 |

---

## 3. 聚合 Adapter 自定义错误码速查

- **AdMob Adapter (`com.google.ads.mediation.admaster`)**：
  - `100` (`ERROR_ADMASTER_SDK`)：底层 SDK 返回错误
  - `101` (`ERROR_INVALID_SERVER_PARAMETERS`)：AdMob 后台 `Parameter` JSON 缺失 `app_id` 或 `ad_unit_id`（注意 AdMob 键名为 `ad_unit_id`）
  - `102` (`ERROR_RESPONSE_EMPTY`)：返回广告为空
  - `103` (`ERROR_AD_NOT_READY`)：展示时广告未就绪
  - `104` (`ERROR_CONTEXT_NOT_ACTIVITY`)：请求或展示时 Context 不是 Activity
- **TopOn Adapter (`cc.admaster.android.topon.*`)**：
  - `1001` (`ERROR_CONFIG`)：TopOn 后台缺失 `app_id` 或 `placement_id`
  - `1002` (`ERROR_INIT_FAILED`)：SDK 初始化失败
  - `1003` / `1004`：同一实例正在加载或竞价中
  - `1005` (`ERROR_NO_AD`)：无广告填充
  - `1006` (`ERROR_SHOW_FAILED`)：展示失败
  - `1007` (`ERROR_AD_EXPIRED`)：广告已过期

---

## 4. 开启调试日志与排障四步法

1. **开启 Debug 日志**：在 `Application.onCreate()` 初始化前调用：
   ```java
   AdMasterSetting.getInstance().setDebugLogEnable(true);
   ```
2. **先看初始化**：过滤 Logcat 确认 `AdMaster.initialize(...)` 已触发 `onInitialized()`，而非 `onFailed(code, msg)`。
3. **区分“代码接入错误”与“线上无填充”**：
   - 若返回 `1030003`、`1040002`、`4000~4004`、`101`、`1001`，属于**客户端调用时序或参数配置错误**。
   - 若返回 `2000`、`3000~3004`、`1040004`，说明**客户端请求已成功到达服务端**，仅当前无填充；此时切换到官方测试 ID（见 `references/test-credentials.md`）即可验证展示与回调闭环。
4. **排查点击/曝光不生效**：
   - 原生广告（`NativeAd`）必须调用 `ad.registerViewForInteraction(container, clickableViews, listener)`。
   - 开屏广告（`SplashAd`）若使用 `SplashAd.load(...)` 两步法，必须在 `onAdLoaded` 中显式调用 `ad.show(container)`。

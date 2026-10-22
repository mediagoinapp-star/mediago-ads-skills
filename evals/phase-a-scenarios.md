# Phase A evaluation scenarios

These scenarios validate Skill behavior without an MCP server. Use sanitized fixture projects and approved release facts only.

| ID | Scenario | Required result |
|---|---|---|
| A1 | Native Android Java direct integration | Inspects the selected app module, resolves one path, shows a file/command plan, and waits for confirmation. |
| A2 | Native Android Kotlin direct integration | Preserves Kotlin conventions and does not create a second Application. |
| A3 | Adapter project with AdMob/MAX/TradPlus | Keeps adapter-owned lifecycle; does not add direct initialization by habit. |
| A4 | TopOn family detection | Maps `com.thinkup.sdk:core-tpn` to international and `com.anythink.sdk:core-tpn` to legacy only with project evidence. |
| A5 | Client Bidding winner | Requires eCPM, expiry check, `notifyWin` before show, and redacts auction values in reports. |
| A6 | Client Bidding loss/expiry | Requires one `notifyLoss`, destroys losing/expired ads, and uses reason `102` only for a higher competing bid. |
| A7 | Plan rejected | Makes no file edit and runs no Gradle command. |
| A8 | Plan drift | Detects a newly needed file/command/dependency/permission and requests a new confirmation. |
| A9 | Unknown SDK error | Requests resolved SDK version, path, format, and redacted message; does not invent an error mapping. |
| A10 | Unity Android bridge project | Detects EDM/template/JNI bridge evidence, routes to the Unity Android bridge workflow, and does not edit generated `Library/` output. |
| A11 | Missing compatibility window | Does not recommend a concrete production version. |
| A12 | Chinese/English parity | Both Skills classify Client Bidding, confirmation drift, and unsupported platforms consistently. |
| A13 | Unity bridge build plan | Requires confirmation before Force Resolve, Android export, Unity build, or Gradle verification. |
| A14 | Unity bridge SNAPSHOT | Reports an unapproved SNAPSHOT dependency as a release blocker and does not claim production compatibility. |

# MediaGo Ads Skills

Agent Skills for integrating and troubleshooting MediaGo Ads in customer applications.

## Skills

- `mediago-ads-integration` — detects the project type and routes to a supported workflow.
- `mediago-ads-android-integration` — integrates MediaGo Ads in native Android Java/Kotlin projects, including direct integration and the AdMob, AppLovin MAX, TradPlus, and TopOn adapters.

## Supported platforms

Native Android is supported. MediaGo does not currently provide an official Unity SDK. The router recognizes Unity projects and explains that boundary instead of inventing an unsupported Unity integration.

## Installation

Install the relevant directory under `skills/` using your agent platform's Git-based Skill installer. Platforms that support a repository-level install may install both directories.

## Safety and support boundaries

The Android Skill inspects a project first, shows a change plan, and requires the customer's explicit confirmation before modifying Gradle files, Android manifests, application code, or running a build. It does not upload source code, use customer dashboard credentials, or submit changes to version control.

Technical SDK guidance is not legal advice. App owners remain responsible for privacy notices, consent flows, data disclosures, and store-policy compliance.

## Versioning

A repository release identifies compatible skill content. Before publishing a release, validate examples against the supported MediaGo SDK and adapter versions, then update the compatibility reference and release notes.

## Chinese-language Skills

Chinese-language equivalents are available for customers who prefer Chinese:

- `mediago-ads-integration-zh`
- `mediago-ads-android-integration-zh`

They have the same product scope and safety gates as their English counterparts. Install one language pair for a customer project to avoid ambiguous routing.

## Release plan

The integrated external-release plan for Skills and the planned MCP package is available in Chinese:

- [`docs/sdk-skill-mcp-plan-zh.md`](docs/sdk-skill-mcp-plan-zh.md)

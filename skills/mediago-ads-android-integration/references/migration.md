# Migration and upgrade

Use this reference for SDK or adapter upgrades, legacy API replacement, or a direct-to-adapter/adapter-to-direct transition.

## Before changes

Inventory the target module's resolved SDK and adapter versions, existing initialization, advertising formats, manifest customizations, ProGuard/R8 files, and test/production credential handling. Show the upgrade plan and request confirmation before edits or dependency commands.

## Migration checklist

- Change only the approved dependency declarations; never hand-edit generated lock/cache/resolution outputs.
- Re-check direct versus adapter ownership after upgrade. Remove duplicate initialization only when the selected path's documentation requires it.
- Revalidate every used ad-format callback, especially reward granting and terminal cleanup.
- Revalidate manifest activities/process overrides and R8 rules.
- Build the target variant and inspect dependency/manifest-merger output.
- Run the selected format's regression checks on a device before reporting device verification.

## Completeness review

A line-by-line API replacement is insufficient. Confirm loading triggers, ready checks, invalid-Activity handling, destruction/cleanup, privacy timing, test configuration isolation, and fallback business flow. If an upgrade crosses an unverified compatibility boundary, stop and request an approved target version.

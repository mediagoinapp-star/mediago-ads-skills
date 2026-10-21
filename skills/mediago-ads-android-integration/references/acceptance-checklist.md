# Acceptance checklist

Use only the checks relevant to the customer's selected path and format.

## All integrations

- Target app variant resolves the approved SDK/adapter combination.
- Exactly one intended initialization owner is present.
- Customer production credentials are not replaced by test credentials.
- Build passes and Manifest merger has no unresolved conflict.
- Load failures preserve the host application's normal flow.

## Full-screen formats

- Load only after initialization/readiness prerequisites.
- Show only with a live, non-finishing, non-destroyed Activity.
- Handle shown, impression, click, dismiss, and show-failure events.
- Clear/destroy the retained instance at the documented terminal point.

## Rewarded

- Grant the reward only from the reward callback.
- Prevent duplicate grants for the same show.
- Dismissal or show failure does not grant a reward.

## Banner and Native

- Banner container has the required layout dimensions and is destroyed with its host.
- Native assets are rendered from supported fields.
- Native root/clickable views are registered exactly as documented.
- Native objects are released with their row/screen lifecycle.

## Evidence report

Report which checks were observed, which were only compiled, and which require customer device/back-office confirmation. Never label an unobserved ad fill or impression as verified.

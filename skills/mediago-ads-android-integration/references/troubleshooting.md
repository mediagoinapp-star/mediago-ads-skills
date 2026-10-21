# Troubleshooting

Collect the exact SDK/adapter version, full error code/message, selected path (direct or adapter), format, app/placement identifiers with secrets redacted, initialization timing, and relevant build or Logcat evidence.

Common checks:

- not initialized: verify `AdMaster.initialize` succeeded before the first direct request;
- network: verify device connectivity and do not add unnecessary permissions;
- invalid configuration: verify the supplied app and placement identifiers with the customer dashboard owner without exposing them in output;
- already loading: prevent concurrent repeated loads for the same logical placement;
- Activity destroyed: show from a live non-finishing/non-destroyed Activity;
- show failure or expired ad: clear the reference, continue app flow, and load a fresh ad at the appropriate time;
- no fill: report the actual returned error. Do not invent a generic no-fill constant or treat no fill as an SDK integration success/failure without evidence;
- Gradle/manifest failure: inspect the full dependency graph or manifest-merger output after customer approval to run the relevant command.

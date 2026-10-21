# Test credentials and configuration

Use official test App IDs and placement IDs only when the customer explicitly asks for a test, demo, or validation and has not provided suitable credentials.

Before writing any test configuration, state: it is test-only; it must not be committed as production configuration; and the customer should replace or isolate it before release.

Use the release-approved public test configuration for the target SDK version. Do not invent values, reuse a customer's production credentials, or obtain test settings through an undocumented backend route. A future MCP may return short-lived, environment-isolated test configuration, but the Skill must work without it.

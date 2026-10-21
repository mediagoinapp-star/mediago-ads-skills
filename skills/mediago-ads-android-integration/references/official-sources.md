# Official sources and fact precedence

Use this precedence order when facts conflict:

1. Release-approved MediaGo compatibility matrix in this repository or its published replacement.
2. Versioned public MediaGo Android integration documentation.
3. Public SDK/API artifacts for the exact resolved version.
4. Customer project evidence.
5. General knowledge only for non-versioned explanation; never for API signatures, adapter class names, coordinates, or compatibility claims.

The current internal maintenance source is not a runtime dependency for external customers. Public Skill releases must embed or link only reviewed, externally accessible material.

## Required fact checks before release

For every supported SDK/adapter release, validate and record:

- Maven coordinates and version strategy;
- MediaGo API signatures and callback behavior;
- required/optional manifest entries;
- adapter class names and console configuration keys;
- supported Android/AGP/Gradle/JDK baseline;
- error-code guidance and test configuration policy.

If the exact fact is not in an approved source, say it is unverified rather than guessing.

# Credential safety

Do not put Google service-account keys in Flutter assets, source, web output or compile-time defines. The old lesson's `assets/credentials.json` pattern was unsafe even when the key was ignored by Git: distributing the app distributes its assets.

The current checkout has no such credential file; the credentials path is ignored and no credentials-path commit appeared in reachable history. This narrow path check is not a complete forensic audit of every historical image/blob. No existing keys were read, tested, rotated or copied. The current app is a local demonstration with no Cloud authentication.

If you followed the old lesson and distributed a real key, treat it as compromised: its owner should revoke/rotate it through Google Cloud, review access logs and replace the client pattern with a server-side identity. Removing a key from a new commit does not revoke it. Historical rewrites are outside this change.

Report a suspected secret privately to the repository owner; never paste it into a public issue. See [the integration boundary](docs/architecture.md) for the proposed remote design and its unverified limits.

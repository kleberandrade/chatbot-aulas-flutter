# Dependencies

Verified against pub.dev and upstream Flutter on 2026-11-17.

Toolchain: Flutter **3.50.0**, Dart **3.14.0**, stable tag/ref `ab2912035e160d9cad6306df307576da6128ebdb`. The isolated SDK reports a user branch because it was checked out by revision; its revision matches the upstream stable ref.

Direct runtime: Flutter SDK and **material_ui 1.11.1**. Direct development: Flutter test SDK and **flutter_lints 6.0.0**. All directly requested packages are current compatible stable releases.

`flutter pub outdated` lists only two newer catalog releases: **material_color_utilities 0.13.1** (resolved **0.13.0**) and **test_api 0.7.15** (resolved **0.7.14**). Flutter SDK constraints pin the older versions; no dependency overrides are used. All remaining resolved stable versions match the catalog at validation time.

## Locked packages

- `async`: 2.13.1

- `boolean_selector`: 2.1.2

- `characters`: 1.4.1

- `clock`: 1.1.3

- `collection`: 1.19.1

- `cupertino_ui`: 1.1.7

- `fake_async`: 1.3.3

- `flutter`: 0.0.0

- `flutter_lints`: 6.0.0

- `flutter_localizations`: 0.0.0

- `flutter_test`: 0.0.0

- `intl`: 0.20.3

- `leak_tracker`: 11.0.2

- `leak_tracker_flutter_testing`: 3.0.10

- `leak_tracker_testing`: 3.0.2

- `lints`: 6.1.0

- `listen`: 1.0.1

- `matcher`: 0.12.20

- `material_color_utilities`: 0.13.0

- `material_ui`: 1.11.1

- `meta`: 1.19.0

- `path`: 1.9.1

- `sky_engine`: 0.0.0

- `source_span`: 1.10.2

- `stack_trace`: 1.12.2

- `stream_channel`: 2.1.4

- `string_scanner`: 1.4.1

- `term_glyph`: 1.2.2

- `test_api`: 0.7.14

- `vector_math`: 2.4.4

- `vm_service`: 15.4.0


The committed lockfile records archive hashes and SDK sources. `flutter pub get --enforce-lockfile` is used in CI. Re-run `flutter pub outdated` after changing the SDK; do not force SDK pins with overrides.


Removed obsolete client dependencies: flutter_dialogflow, cupertino_icons and their old HTTP/Google authentication chain. The app has no remote adapter. Pub.dev records: [material_ui](https://pub.dev/packages/material_ui), [flutter_lints](https://pub.dev/packages/flutter_lints).

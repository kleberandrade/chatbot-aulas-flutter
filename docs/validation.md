# Validation record

Verified on 2026-11-17 with Flutter 3.50.0 / Dart 3.14.0, framework `ab2912035e160d9cad6306df307576da6128ebdb`, macOS and Chrome 157.0.8103.79.

Reproduce from the repository root with this SDK:

```sh
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --coverage
flutter build web --release
python3 -m http.server 8783 --bind 127.0.0.1 --directory build/web
```

Open `http://127.0.0.1:8783` in Chrome. This serves a local build and does not publish/deploy it.

Eleven tests pass: local greeting/intent/entity/course/integration/thanks/help/fallback behavior; trimming and empty/501-point rejection; 500-point Unicode acceptance; ordering/IDs/timestamps/immutable transcript; one in-flight turn; failure and retry without duplication; reset with a new pending turn and stale completion; dispose, timeout and empty response; keyboard send and reset; widget input validation; pending/error/retry/disposal UI; narrow viewport and 2× text. The first red runs are saved in `tdd-domain-red.txt` and `tdd-widget-red.txt`; later corrections are described in the action log. Not every later assertion was written before implementation.

Static analysis reports no issues. The release JavaScript web build succeeds, including Flutter's Wasm dry run; this is not a separately tested Wasm release. Coverage is generated in `coverage/lcov.info` and uploaded by CI, with no invented percentage badge.

`crapper --help`, `dryer --help`, `mutator --help` confirmed these installed tools do not support Dart. No mutation/CRAP/duplication score is reported. Flutter tests and a manual review are the applicable checks.

Native Android/iOS templates were refreshed, but native builds/device execution are unverified. Android licenses remain pending. No licenses were accepted, no service credentials were used, and no cloud integration was exercised.

Real Chrome UI verification and publication evidence are recorded in the modernization log and Medium verification files. Screenshots in `docs/images/app-*.jpg` depict the executed web release rather than native phone execution. The conceptual cover is an AI-generated illustration and is never offered as an app screenshot.

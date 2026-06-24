# AGENTS.md

## Cursor Cloud specific instructions

This is a Flutter mobile app (`tiki` / "Touch Voice"), an Android/iOS live‑streaming app.
The backend is a hosted Back4App Parse server with keys hard‑coded in
`lib/data/app/config.dart`, so no local backend or database needs to be run.

### Toolchain (pre-installed in the VM snapshot)
- Flutter `3.44.3` stable (Dart `3.12.2`) at `/opt/flutter`.
- Android SDK at `/opt/android-sdk` (platform 36, build-tools 36.0.0, platform-tools,
  NDK `28.2.13676358`, CMake `3.22.1`).
- `~/.bashrc` exports `PATH` (Flutter + Android cmdline-tools/platform-tools) and
  `ANDROID_SDK_ROOT`/`ANDROID_HOME` for interactive shells. Non-interactive scripts
  that don't source `~/.bashrc` should call Flutter by absolute path
  (`/opt/flutter/bin/flutter`) or export these vars first.

### Common commands (run from repo root)
- Install deps: `flutter pub get` (also run automatically by the update script).
- Lint: `flutter analyze` (passes clean; `analysis_options.yaml` downgrades many lints).
- Tests: there is no `test/` directory in the app, so `flutter test` reports
  "Test directory not found" — there are no automated tests to run.
- Build (dev): `flutter build apk --debug` produces
  `build/app/outputs/flutter-apk/app-debug.apk`.

### Non-obvious notes
- Only `android/` and `ios/` platforms exist — there is no `web/` or `linux/` folder,
  so the app cannot be built/run for web or Linux desktop (the only devices Flutter
  auto-detects here, Chrome/Linux, are not usable for this app).
- The app cannot be run on an emulator/device in this cloud VM: there is no `/dev/kvm`,
  so a hardware-accelerated Android emulator cannot boot. Use the debug APK build as the
  build/run verification path; actual UI runtime requires a physical/virtual Android device.
- The first `flutter build apk` downloads the Gradle distribution and all Android
  dependencies and auto-installs CMake; it can take ~10+ minutes. Later builds are faster.
- Release signing is not configured (`android/key.properties` is absent), so use
  `--debug` builds. `android/local.properties` is generated automatically by Flutter.
- `flutter doctor` shows a cosmetic warning that the Flutter git remote is "not a standard
  remote"; this is caused by the environment's git credential URL rewriting and is harmless.

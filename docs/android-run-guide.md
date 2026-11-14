# Run on an Android phone

Setup already present on this machine: Android SDK (`~/Android/Sdk`), JDK 17, Godot 4.7.2 export templates,
and the Godot debug keystore. `export_presets.cfg` is gitignored (local), so recreate it via
Project > Export > Add > Android on another machine (package `com.nxdinh.mygame`, arm64-v8a).

## 1. Prepare the phone (once)
1. Settings > About phone > tap **Build number** 7 times (enables Developer options).
2. Settings > Developer options > turn on **USB debugging**.
3. Connect by USB cable. Accept the "Allow USB debugging?" prompt on the phone.

## 2. Verify the phone is seen
```bash
~/Android/Sdk/platform-tools/adb devices
```
It must list your device as `device` (not `unauthorized`).

## 3a. One command: export + install + launch
```bash
./tools/run-android.sh
```
It exports, checks the signature, installs and launches. Manual steps:
```bash
godot --headless --path . --export-debug "Android Debug" build/my-game-debug.apk
~/Android/Sdk/platform-tools/adb install -r build/my-game-debug.apk
~/Android/Sdk/platform-tools/adb shell monkey -p com.nxdinh.mygame -c android.intent.category.LAUNCHER 1
```

## 3b. Or from the editor
Open the project in Godot, click the **Android icon** (top right, "Remote Debug") and pick your device
(or press F5 with the device selected). Godot builds, installs and launches it.

## Expected result
Dark portrait screen, top-left label "my-game / Tap a tile / Selected / FPS", and a green isometric
7x7 grid. Tapping a tile turns it yellow. The Android Back button quits.

## Troubleshooting
- `INSTALL_PARSE_FAILED_NO_CERTIFICATES`: the APK is unsigned (an editor "Export Project" did this once). Re-run `./tools/run-android.sh`.
- `INSTALL_FAILED_USER_RESTRICTED`: enable "Install via USB" in Developer options.
- `adb devices` empty: try another cable/port; `adb kill-server && adb devices`.
- `unauthorized`: revoke USB debugging authorizations on the phone, reconnect, accept again.
- Export error "valid Java SDK path": Editor Settings > Export > Android > Java SDK Path = `/usr/lib/jvm/java-17-openjdk`.
- Logs: `~/Android/Sdk/platform-tools/adb logcat -s godot`.
- Orientation/size: Project Settings > Display > Window > Handheld (currently portrait, 720x1280).
- Play Store later needs a release keystore and an AAB (needs Gradle build); not needed for testing.

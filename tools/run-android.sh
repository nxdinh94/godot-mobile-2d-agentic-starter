#!/usr/bin/env bash
# Export a signed debug APK, install it on the connected phone, launch it, and verify the signature.
set -euo pipefail
cd "$(dirname "$0")/.."
ADB="$HOME/Android/Sdk/platform-tools/adb"
APKSIGNER="$HOME/Android/Sdk/build-tools/36.0.0/apksigner"
APK="build/my-game-debug.apk"
PKG="com.nxdinh.mygame"

"$ADB" get-state >/dev/null 2>&1 || { echo "No phone found. Plug it in and allow USB debugging."; exit 1; }
godot --headless --path . --export-debug "Android Debug" "$APK"
"$APKSIGNER" verify "$APK" || { echo "APK is not signed."; exit 1; }
"$ADB" install -r "$APK"
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null
echo "Launched $PKG. Logs: $ADB logcat -s godot"

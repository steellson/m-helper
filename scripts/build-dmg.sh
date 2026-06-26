#!/usr/bin/env bash
#
# Builds a Release m-helper.app and packages it into a DMG with a custom
# volume icon. Requires only Xcode (no external dependencies).
#
# Run from the repo root:
#   ./scripts/build-dmg.sh
#
# Output: build/m-helper.dmg — open it and drag the app into Applications.

set -euo pipefail

APP_NAME="m-helper"
PROJECT="$APP_NAME.xcodeproj"
TARGET="$APP_NAME"
CONFIG="Release"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT/build"
PRODUCTS="$BUILD_DIR/products"
APP_PATH="$PRODUCTS/$APP_NAME.app"
STAGING="$BUILD_DIR/dmg"
ICONSET="$BUILD_DIR/$APP_NAME.iconset"
ICNS="$BUILD_DIR/VolumeIcon.icns"
RW_DMG="$BUILD_DIR/$APP_NAME-rw.dmg"
DMG_PATH="$BUILD_DIR/$APP_NAME.dmg"
APPICONSET="$ROOT/m-helper/Resources/Assets.xcassets/AppIcon.appiconset"

cd "$ROOT"
rm -rf "$BUILD_DIR"
mkdir -p "$STAGING" "$ICONSET"

# 1. Build the Release .app.
#    CONFIGURATION_BUILD_DIR drops the product at a known path (no -scheme needed).
#    Ad-hoc signing (CODE_SIGN_IDENTITY="-") lets anyone build & run it locally
#    without an Apple Developer account.
#    Lean distribution build: strip symbols, no .dSYM.
xcodebuild \
  -project "$PROJECT" \
  -target "$TARGET" \
  -configuration "$CONFIG" \
  CONFIGURATION_BUILD_DIR="$PRODUCTS" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="" \
  DEBUG_INFORMATION_FORMAT=dwarf \
  DEPLOYMENT_POSTPROCESSING=YES \
  STRIP_INSTALLED_PRODUCT=YES \
  COPY_PHASE_STRIP=YES \
  build

# 2. Build an .icns for the DMG volume icon from the app's icon set.
cp "$APPICONSET"/*.png "$ICONSET/"
iconutil -c icns "$ICONSET" -o "$ICNS"

# 3. Lay out DMG contents: the app + an /Applications shortcut for drag-n-drop.
cp -R "$APP_PATH" "$STAGING/"
ln -s /Applications "$STAGING/Applications"
cp "$ICNS" "$STAGING/.VolumeIcon.icns"

# 4. Create a read-write DMG, flag the custom volume icon, then compress it.
hdiutil create -volname "$APP_NAME" -srcfolder "$STAGING" \
  -ov -format UDRW "$RW_DMG"

MOUNT_DIR="$(mktemp -d)"
hdiutil attach "$RW_DMG" -nobrowse -noverify -mountpoint "$MOUNT_DIR"
SetFile -a C "$MOUNT_DIR"
hdiutil detach "$MOUNT_DIR" -quiet
rmdir "$MOUNT_DIR" 2>/dev/null || true

hdiutil convert "$RW_DMG" -format UDZO -ov -o "$DMG_PATH"
rm -f "$RW_DMG"

echo ""
echo "Done: $DMG_PATH"

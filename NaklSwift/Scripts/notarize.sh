#!/bin/bash
set -euo pipefail

if [ -z "${APPLE_ID:-}" ] || [ -z "${TEAM_ID:-}" ] || [ -z "${APP_PASSWORD:-}" ]; then
    echo "Set APPLE_ID, TEAM_ID, and APP_PASSWORD environment variables"
    exit 1
fi

APP_PATH="${1:-build/Release/NAKL 2.0.app}"
DMG_PATH="${2:-build/NAKL2.dmg}"

echo "Creating DMG..."
hdiutil create -volname "NAKL 2.0" -srcfolder "$APP_PATH" -ov -format UDZO "$DMG_PATH"

echo "Submitting for notarization..."
xcrun notarytool submit "$DMG_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_PASSWORD" \
    --wait

echo "Stapling..."
xcrun stapler staple "$DMG_PATH"

echo "Done: $DMG_PATH"

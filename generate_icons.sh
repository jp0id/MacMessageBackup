#!/bin/bash
set -e

APP_ICON_DIR="/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets/AppIcon.appiconset"
MENU_ICON_DIR="/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets/MenuBarIcon.imageset"
SOURCE_ICON="$APP_ICON_DIR/icon_512x512@2x.png"

echo "Creating MenuBarIcon directory..."
mkdir -p "$MENU_ICON_DIR"

if [ ! -f "$SOURCE_ICON" ]; then
    echo "Source icon not found at $SOURCE_ICON"
    exit 1
fi

echo "Generating icons..."
sips -z 16 16 "$SOURCE_ICON" --out "$MENU_ICON_DIR/icon_1x.png"
sips -z 32 32 "$SOURCE_ICON" --out "$MENU_ICON_DIR/icon_2x.png"

echo "Writing Contents.json..."
cat > "$MENU_ICON_DIR/Contents.json" <<EOF
{
  "images" : [
    {
      "filename" : "icon_1x.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "icon_2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "Done."

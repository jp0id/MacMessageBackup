#!/bin/bash
set -e

# Configuration
SOURCE_IMAGE="/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png"
ASSETS_DIR="/Volumes/SSD/Projects/MacMessageBackupApp/MacMessageBackup/Assets.xcassets"
APP_ICON_SET="$ASSETS_DIR/AppIcon.appiconset"
MENU_ICON_SET="$ASSETS_DIR/MenuBarIcon.imageset"

echo "📍 Source Image: $SOURCE_IMAGE"

if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "❌ Error: Source image not found!"
    exit 1
fi

# 1. Prepare AppIcon.appiconset
echo "🔨 Generating App Icons..."
mkdir -p "$APP_ICON_SET"

# Create Master PNG 1024x1024
sips -s format png -z 1024 1024 "$SOURCE_IMAGE" --out "$APP_ICON_SET/app_icon_1024.png" > /dev/null

# Generate sizes
sips -z 16 16     "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_16x16.png" > /dev/null
sips -z 32 32     "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_16x16@2x.png" > /dev/null
sips -z 32 32     "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_32x32.png" > /dev/null
sips -z 64 64     "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_32x32@2x.png" > /dev/null
sips -z 128 128   "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_128x128.png" > /dev/null
sips -z 256 256   "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_128x128@2x.png" > /dev/null
sips -z 256 256   "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_256x256.png" > /dev/null
sips -z 512 512   "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_256x256@2x.png" > /dev/null
sips -z 512 512   "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$APP_ICON_SET/app_icon_1024.png" --out "$APP_ICON_SET/icon_512x512@2x.png" > /dev/null

# Update Contents.json for AppIcon
cat > "$APP_ICON_SET/Contents.json" <<EOF
{
  "images" : [
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "icon_16x16.png",
      "scale" : "1x"
    },
    {
      "size" : "16x16",
      "idiom" : "mac",
      "filename" : "icon_16x16@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "icon_32x32.png",
      "scale" : "1x"
    },
    {
      "size" : "32x32",
      "idiom" : "mac",
      "filename" : "icon_32x32@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "icon_128x128.png",
      "scale" : "1x"
    },
    {
      "size" : "128x128",
      "idiom" : "mac",
      "filename" : "icon_128x128@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "icon_256x256.png",
      "scale" : "1x"
    },
    {
      "size" : "256x256",
      "idiom" : "mac",
      "filename" : "icon_256x256@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "icon_512x512.png",
      "scale" : "1x"
    },
    {
      "size" : "512x512",
      "idiom" : "mac",
      "filename" : "icon_512x512@2x.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF

# 2. Prepare MenuBarIcon.imageset
echo "🔨 Generating Menu Bar Icons..."
mkdir -p "$MENU_ICON_SET"

# Menu bar icons should be monochromatic/template for best system integration, 
# but user wants the custom icon. Resizing the colored one.
sips -z 19 19 "$APP_ICON_SET/app_icon_1024.png" --out "$MENU_ICON_SET/icon_1x.png" > /dev/null
sips -z 38 38 "$APP_ICON_SET/app_icon_1024.png" --out "$MENU_ICON_SET/icon_2x.png" > /dev/null
sips -z 57 57 "$APP_ICON_SET/app_icon_1024.png" --out "$MENU_ICON_SET/icon_3x.png" > /dev/null

cat > "$MENU_ICON_SET/Contents.json" <<EOF
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
      "filename" : "icon_3x.png",
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

# 3. Clean Derived Data to force asset reload
echo "🧹 Cleaning DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/MacMessageBackup-*

echo "✅ Done. Icons regenerated."

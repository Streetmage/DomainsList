# Build utility
TARGET="DomainsUpdater"
CONFIG="Debug"
xcodebuild -project DomainsList.xcodeproj -scheme $TARGET -configuration $CONFIG -destination 'generic/platform=macOS'
# Get BUILD_ROOT and SRCROOT from utility project settings
BUILD_SETTINGS=`xcodebuild -project DomainsList.xcodeproj -scheme $TARGET -showBuildSettings`
BUILD_ROOT=`echo "$BUILD_SETTINGS" | grep BUILD_ROOT | sed -e "s/^    BUILD_ROOT = //"`
SRCROOT=`echo "$BUILD_SETTINGS" | grep SRCROOT | sed -e "s/^    SRCROOT = //"`
# Start utility
$BUILD_ROOT/$CONFIG/$TARGET update \
"https://raw.githubusercontent.com/Streetmage/DomainsList/main/remote_domains.json" \
"$SRCROOT/DomainsList/Resources/domains.json" \
"$SRCROOT/DomainsList/Resources/Info.plist"

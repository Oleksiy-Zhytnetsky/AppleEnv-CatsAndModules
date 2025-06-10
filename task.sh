# For your convenience 
alias PlistBuddy=/usr/libexec/PlistBuddy

# IMPLEMENT: 
# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS

# IMPLEMENT:
# Clean build folder
WORKSPACE="CatsAndModules_OleksiyZhytnetskyi.xcworkspace"
SCHEME="CatsUI"
CONFIG=Release

xcodebuild clean \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}"

# IMPLEMENT:
# Create archive
ARCHIVE_PATH="./release.xcarchive"
DEST="generic/platform=iOS"

xcodebuild archive \
-archivePath "${ARCHIVE_PATH}" \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}" \
-destination "${DEST}"

# IMPLEMENT:
# Export archive
rm exportOptions.plist
PLIST="exportOptions.plist"
CERTIFICATE_NAME="Apple Development: Oleksandr Frankiv (3LK7D4G6NM)"
TEAM_ID="D85QWSUNYA"
BUNDLE_ID="ua.edu.ukma.apple-env.zhytnetskyi.CatsUI"
PROFILE_UUID="b7dfe22a-564d-41a5-8ca2-e1ffbe983b91"
EXPORT_PATH="./Exported"

PlistBuddy -c "Add :destination string export" $PLIST
PlistBuddy -c "Add :method string debugging" $PLIST
PlistBuddy -c "Add :signingStyle string manual" $PLIST
PlistBuddy -c "Add :teamId string '${TEAM_ID}'" $PLIST
PlistBuddy -c "Add :signingCertificate string '${CERTIFICATE_NAME}'" $PLIST
PlistBuddy -c "Add :provisioningProfiles dict" $PLIST
PlistBuddy -c "Add :provisioningProfiles:'${BUNDLE_ID}' string '${PROFILE_UUID}'" $PLIST

xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${EXPORT_PATH}" \
-exportOptionsPlist "${PLIST}"

rm -rf "${ARCHIVE_PATH}"

echo "Task completed!"

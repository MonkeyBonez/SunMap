#!/bin/sh
# Install Sun Map on the phone and sideload the tiled metros into its
# Application Support/Cities (there is no public bundle server yet). Phone must be unlocked.
# The bundle id is still com.likewater.sunmap (kept from before the split).
set -e
DEV=${DEV:-ECD3EF26-97FB-5D2F-8379-9516C6A8BBE9}
BID=com.likewater.sunmap
cd "$(dirname "$0")"
P=$(ls -dt ~/Library/Developer/Xcode/DerivedData/SunMap-*/Build/Products/Debug-iphoneos | head -1)
xcrun devicectl device install app --device $DEV "$P/SunMap.app" | grep -E "installed|App installed" || true
for id in ${METROS:-seattle nyc la}; do
  echo "== $id"
  xcrun devicectl device copy to --device $DEV --domain-type appDataContainer --domain-identifier $BID \
    --source "Server/$id" --destination "Library/Application Support/Cities/$id" --quiet
done
xcrun devicectl device process launch --device $DEV $BID | grep Launched || true

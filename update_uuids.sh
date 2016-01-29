#!/bin/bash
# Lists all UUIDs of installed Xcodes and add them to the plugin plist file

DEST="`pwd`/SYXcodeIconVersion/Info.plist"

# add UUIDs of all present Xcode
for x in /Applications/Xcode*.app/Contents/Info.plist; do 
	UUID=`defaults read $x DVTPlugInCompatibilityUUID`
	echo "Adding $UUID..."
	defaults write $DEST DVTPlugInCompatibilityUUIDs -array-add $UUID
done

# remove duplicates
UUIDs=()
STOP=0
while [ $STOP -eq 0 ]; do
    UUID=`/usr/libexec/PlistBuddy -c "Print :DVTPlugInCompatibilityUUIDs:${#UUIDs[@]}" $DEST 2>/dev/null`
    if [ $? -eq 0 ]; then
        UUIDs+=($UUID)
    else
        STOP=1
    fi
done

echo "Found ${#UUIDs[@]} items"

# keep unique items, ordered
# http://stackoverflow.com/a/30377684/1439489
UUIDs=($(tr ' ' '\n' <<<"${UUIDs[@]}" | awk '!u[$0]++' | tr '\n' ' '))

echo "Removed duplicates, ${#UUIDs[@]} items remaining"

# remove old items
/usr/libexec/PlistBuddy -c "Delete :DVTPlugInCompatibilityUUIDs" $DEST

# add unique items
for UUID in "${UUIDs[@]}"; do
    defaults write $DEST DVTPlugInCompatibilityUUIDs -array-add $UUID
done
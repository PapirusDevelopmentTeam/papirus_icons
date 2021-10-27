#!/bin/sh
# This script download apk from Google Play and grab launchable activity and icon.
# Dependencies:
# gplaydl wget google-play-scraper aapt
# How it's worked:
# Only paste needed packages names on list.txt and run script. For example:
# com.google.android.apps.youtube.music
# com.spotify.music
for entry in $(cat list.txt)
do
export PACKAGE="$entry"
# download package from Google Play
gplaydl download --packageId $PACKAGE
# set package name on scraper for download icon from Google Play
sed -i "s/PACKAGE/$PACKAGE/g" scraper.py
# download icon from Google Play
wget --quiet -O icons/$PACKAGE.png $(python3 scraper.py)
# restore scraper
sed -i "s/$PACKAGE/PACKAGE/g" scraper.py
# get package label from apk
aapt dump badging $PACKAGE.apk | grep -oP "(?<=application-label:')[^*]+" | awk '{print tolower($0)}' | sed "s/'$//" | sed "s/\ /_/g" | sed "s/-/_/g" >> result.txt
# get package name from apk
aapt dump badging $PACKAGE.apk | sed -n "/package/ s/.*name=.\([a-zA-Z0-9._-]\+\)..*/\1/p" >> result.txt
# get launch activity from apk
aapt dump badging $PACKAGE.apk | sed -n "/launchable-activity/ s/.*name=.\([a-zA-Z0-9._-]\+\)..*/\1/p" >> result.txt
# add separator
echo "*********" >> result.txt
# clean
rm -rf $PACKAGE
rm -rf $PACKAGE.apk
done

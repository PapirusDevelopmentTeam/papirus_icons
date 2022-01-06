#!/bin/sh
# This script download apk from Google Play and grab launchable activity and icon.
# Dependencies:
# googleplay https://github.com/89z/googleplay
# wget https://www.gnu.org/software/wget/
# play-scraper https://github.com/danieliu/play-scraper
# aapt https://android.googlesource.com/platform/frameworks/base/
# How it's worked:
# First you need create Application Password on Google Account for "googleplay" tool.
# Next step - create Auth Token:
# googleplay -e EMAIL -p APP_PASSWORD
# Add Android_ID for future requests:
# googleplay -d
# Now only paste needed packages names on list.txt and run script. For example, list.txt:
# com.google.android.apps.youtube.music
# com.spotify.music
for entry in $(cat list.txt)
do
export PACKAGE="$entry"
mkdir -p icons
# get package VersionCode
export VERSIONCODE=$(googleplay -a $PACKAGE | grep VersionCode | sed "s/VersionCode\:\ //g")
# purchase package from Google Play
googleplay -a $PACKAGE -purchase
# download package from Google Play
googleplay -a $PACKAGE -v $VERSIONCODE
# set package name on scraper for download icon from Google Play
sed -i "s/PACKAGE/$PACKAGE/g" scraper.py
# download icon from Google Play
wget --quiet -O icons/$PACKAGE.png $(python3 scraper.py)
# restore scraper
sed -i "s/$PACKAGE/PACKAGE/g" scraper.py
# get package label from apk
aapt dump badging $PACKAGE-*.apk | grep -oP "(?<=application-label:')[^*]+" | awk '{print tolower($0)}' | sed "s/'$//" | sed "s/\ /_/g" | sed "s/-/_/g" >> result.txt
# get package name from apk
aapt dump badging $PACKAGE-*.apk | sed -n "/package/ s/.*name=.\([a-zA-Z0-9._-$]\+\)..*/\1/p" >> result.txt
# get launch activity from apk
aapt dump badging $PACKAGE-*.apk | sed -n "/launchable-activity/ s/.*name=.\([a-zA-Z0-9._-$]\+\)..*/\1/p" >> result.txt
# add separator
echo "*********" >> result.txt
# clean
rm -rf *.apk
done

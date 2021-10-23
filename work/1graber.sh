#!/bin/sh
# This script download apk from Google Play and grab launchable activity and icon.
# Dependencies:
# gplaydl unzip androguard aapt
# How it's worked:
# Only paste needed packages names on list.txt and run script. For example:
# com.google.android.apps.youtube.music
# com.spotify.music
for entry in $(cat list.txt)
do
export PACKAGE="$entry"
# download package from Google Play
gplaydl download --packageId $PACKAGE
# unpack package for grab icon
unzip -qq $PACKAGE.apk -d $PACKAGE
# parse AndroidManifest.xml
androguard axml $PACKAGE.apk -o output.xml
# get icon ID from apk
androguard arsc $PACKAGE.apk --id $(grep -m 1 -oP '(?<=android:icon="@)[a-zA-Z0-9]+' output.xml) | grep ".png" | tail -1 >> icon.sh
androguard arsc $PACKAGE.apk --id $(grep -m 1 -oP '(?<=android:icon="@)[a-zA-Z0-9]+' output.xml) | grep ".webp" | tail -1 >> icon.sh
# set copy icon to this directory
sed -i "s/.*\=\ '/cp\ '$PACKAGE\//g" icon.sh
# fix
sed -i "s/png'/png'\ 'icons\/$PACKAGE\.png'/g" icon.sh
sed -i "s/webp'/webp'\ 'icons\/$PACKAGE\.webp'/g" icon.sh
chmod +x icon.sh
# copy icon
./icon.sh
# get package label from apk
aapt dump badging $PACKAGE.apk | grep -oP "(?<=application-label:')[^*]+" | awk '{print tolower($0)}' | sed "s/'$//" | sed "s/\ /_/g" | sed "s/-/_/g" >> result.txt
# get package name from apk
aapt dump badging $PACKAGE.apk | sed -n "/package/ s/.*name=.\([a-zA-Z0-9.]\+\)..*/\1/p" >> result.txt
# get launch activity from apk
aapt dump badging $PACKAGE.apk | sed -n "/launchable-activity/ s/.*name=.\([a-zA-Z0-9.]\+\)..*/\1/p" >> result.txt
# add separator
echo "*********" >> result.txt
# clean
rm -rf $PACKAGE
rm $PACKAGE.apk
rm output.xml
rm icon.sh
done

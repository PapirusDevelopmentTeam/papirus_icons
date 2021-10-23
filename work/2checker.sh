#!/bin/sh
# List failed downloading apk's
ls icons/ > compare.txt
sed -i "s/\.png//g" compare.txt
sed -i "s/\.webp//g" compare.txt
grep -vxFf compare.txt list.txt > failed.txt
echo "This packages can not be downloaded from Google Play! Please check package name or this paid app."
rm compare.txt
cat failed.txt

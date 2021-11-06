#!/bin/sh
# List failed downloading apk's
grep -vxFf result.txt list.txt > failed.txt
echo "This packages can not be downloaded from Google Play! Please check package name or this paid app."
cat failed.txt

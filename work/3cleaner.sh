#!/bin/sh
# Delete all files
rm -rf icons/*.png
rm -rf icons/*.webp
rm list.txt output.txt failed.txt
touch list.txt
echo "application_name" >> output.txt
echo "package_name" >> output.txt
echo "launchable_activity" >> output.txt
echo "*********" >> output.txt

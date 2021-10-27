#!/bin/sh
# Delete all files
echo -n "Delete all working files? (Y/n) "
read item
case "$item" in
    y|Y) echo "Files deleted!"
        ;;
    n|N) echo "Canceled!"
        exit 0
        ;;
    *) echo "Files deleted!"
        ;;
esac
rm -rf icons/*.png
rm list.txt result.txt failed.txt
touch list.txt
echo "application_name" >> result.txt
echo "package_name" >> result.txt
echo "launchable_activity" >> result.txt
echo "*********" >> result.txt

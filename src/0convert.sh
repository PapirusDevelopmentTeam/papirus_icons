#!/bin/bash
rm -r drawable/*.png
for file in *.svg; do rsvg-convert -h 192 -w 192 $file > drawable/$file.png; done
rename s/.svg//g drawable/*.png
rm -r ../app/src/main/res/drawable-nodpi/*.png
cp drawable/*.png ../app/src/main/res/drawable-nodpi/

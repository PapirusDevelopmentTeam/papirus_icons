echo "Create list icons from Appfilter"
cp ../app/src/main/res/xml/appfilter.xml convert-mi.sh
sed -i 's/\/[^\]*}\"\ drawable\=\"/\.png\ /g' convert-mi.sh
sed -i 's/\}\"\ drawable\=\"/\.png\ /g' convert-mi.sh
sed -i 's/[^\]*{/res\/drawable-xxhdpi\//g' convert-mi.sh
sed -i 's/\"\/>/\.png/g' convert-mi.sh
sed -i 's/<[^\]*>//g' convert-mi.sh
sed -i 's/^\(.*\) \(.*\)/\2 \1/g' convert-mi.sh
sed -i '/^$/d' convert-mi.sh
sort -u convert-mi.sh -o convert-mi.sh
sed -i 's/^/cp\ \.\.\/app\/src\/main\/res\/drawable-nodpi\//' convert-mi.sh
chmod +x convert-mi.sh
echo "Copy icons"
./convert-mi.sh
rm convert-mi.sh
echo "Pack icons"
zip -q -r icons res
mv icons.zip icons
zip -q -r papirus-icon-pack.mtz icons preview description.xml
echo "Remove template files"
rm icons
rm -rf res/drawable-xxhdpi/*.png

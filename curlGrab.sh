#! /bin/bash

#Function to decode url symbols (ie. %3a -> :)
function urldecode {
	local url_encoded="${1//+/ }"
	printf "%b" "${url_encoded//%/\\x}\n" >> "decoded-$2"
}

#Grabs all websites and adds html source code to corresponding file
curl -s -L 'ww5.readsnk.com/chapter/shingeki-no-kyojin-chapter-[021-105]' -o '#1.html'

#Searches the html source code to find all instances of images related to the comic
# and replaces the file with the updated one
for file in {021..105}.html; do
	grep -oh '2.bp.blogspot.com.*\(png\|jpg\)' < "$file" > "url-$file"
	rm $file
done

#Decodes all the files to get the raw links to the pictures
# and adds them to a new file, destroying the old one
for file in url-{021..105}.html; do
	while read p; do
		urldecode $p $file
	done < $file
	rm $file
done

#Downloads all the images to a corresponding sub-directory
# and deletes the remaining files
for file in decoded-url-{021..105}.html; do
	x=$file
	y=${x%.html}
	name=${y##*-}
	while read p; do
		x1=$p
		y1=${x1%.*}
		name1=$y1.jpg
		wget -q -P $PWD/$name/ $name1
	done < $file
	rm $file
done
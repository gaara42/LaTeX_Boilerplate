#!/bin/bash
# biafra ahanonu
# 2013.02.23
# script to make playlists

# Yes/No function
getYesNo(){
	select terminateSignal in "Yes" "No"
	do
		case $terminateSignal in
			"Yes" )
				return 1;;
			"No" ) 
				return 0;;
		esac
	done	
}

# Change file separator to allow use of files with spaces
oldIFS=$IFS
IFS=$(echo -en "\n\b")

# Ask user for directory
echo "Directory? "
read userDir
echo $userDir
cd $userDir  

# Ask to remove old .m3u files
echo "Remove old .m3u files? "
getYesNo
response=$?
if [[ $response == 1 ]]; then
	find . -regex '.*\.m3u' -delete
fi

# Get file extensions to search for
fileExt='mp3,wma,aac,flac,ogg,m4a,m4p,wav'
echo 'Current search file extensions: '$fileExt
echo "Add more extensions? "
getYesNo
response=$?
if [[ $response == 1 ]]; then
	echo "List extensions, separated by a comma: "
	read fileExtUser
	fileExt=$fileExt$fileExtUser
fi

# Convert to find ready form
fileExt=$(echo $fileExt | sed 's/,/\\|/g')
fileExt='.*\.\('$fileExt'\)'

# Loop over all folders in directory and add playlist to the root folder
for folder in $(ls -d */); do
	playlistName=$(echo $folder | sed 's/\///g;s/ /_/g')
	folderName=$(echo $folder | sed 's/\///g')
	find "$folder" -regex $fileExt | sed "s/${folderName}\///g" > $folder$playlistName".m3u"
	# find "$folder" -type f | sed "s/${folderName}\///g" > $folder$playlistName".m3u"
	# find "$i" -type f | sed 's/$i\//.\//g'> $playlistName".m3u"
	echo $playlistName".m3u"
done

# Return file separator to default
IFS=$oldIFS
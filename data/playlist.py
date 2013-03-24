#!/Python27/env python
#Biafra Ahanonu
#2012.12.02

#Makes .m3u extended playlist at first level folders in a directory

#Modules used
import os,re,time
#Import settings from settings.py
from settings import *
#Help filter out duplicates
from sets import Set

def folderBrowser():
	#Opens a folder
	import Tkinter, tkFileDialog
	root = Tkinter.Tk()
	root.withdraw()
	dir = tkFileDialog.askdirectory(parent=root,initialdir=DEFAULT_DIR,title='Please select a directory')
	return dir

def fileTree(dir,relDir):
	#Crawls through a directory and finds audio files, returns list of files
	print dir

	#Variable to save files to
	filesToSave = []

	#Valid mp3 files
	validFiles = set(VALID_AUDIO_FORMATS)

	#Crawl through directory
	for dirname, dirnames, filenames in os.walk(dir):

		#Crawl through each directory in a folder
		for subdirname in dirnames:
			#Next level relative path
			relDir2 = os.path.join(relDir,subdirname)

			#Evaluate each file in directory, if audio, add to playlist
			for filename in os.listdir(os.path.join(dir,subdirname)):
				#If there is an intersection, means valid extension, add to playlist
				if validFiles.intersection(set(filename.split('.'))):
					filesToSave.append(os.path.join(relDir2,filename))

			#Recursion here
			#After finding all file in a subdirectory, crawl through its folders		
			filesToSave=filesToSave+fileTree(os.path.join(dir,subdirname),relDir2)

		#Finally, get files in root directory, see above for explanation of details
		for filename in os.listdir(os.path.join(dir,'')):
			if validFiles.intersection(set(filename.split('.'))):
				filesToSave.append(os.path.join(relDir,filename))

		#Break the loop so we don't crawl through subdirectories and add playlists there
		break
	
	#Return files found
	return filesToSave

def saveFilesToPlaylist(files,dir,dirname,CURRENT_DIR):
	#Saves a list of files to a playlist

	#Open connection, uses root as name for playlist
	try:
		playlist = open(os.path.join(CURRENT_DIR,dirname,dirname+PLAYLIST_ID_TAG+'.m3u'),'w')
	except Exception, e:
		return
	#Output playlist location
	print os.path.join(CURRENT_DIR,dirname,dirname+PLAYLIST_ID_TAG+'.m3u')
	
	#Extended M3U format used here
	if EXTENDED_M3U == 1:
		playlist.write('#EXTM3U\n')

	#Remove duplicates
	files = sorted(set(files))

	#Loop through each file
	for filename in files:
		if EXTENDED_M3U == 1:
			actualFilename = os.path.basename(filename)
			#Split then rejoin, remove extension
			filenameName = actualFilename.split('.')
			filenameName = '.'.join(filenameName[0:-1])
			#Add name based filename
			try:
				playlist.write('#EXTINF:'+filenameName+'\n')
			except Exception, e:
				continue
		#Write relative location of file
		playlist.write(os.path.join(filename)+'\n')

	#Close file id
	playlist.close()

def main():
	#Ask user for folder
	dir = folderBrowser()
	#If no folder given, use default
	CURRENT_DIR = dir or DEFAULT_DIR
	#Print the current directory
	print CURRENT_DIR

	#Log all the playlist created
	logFileName = os.path.basename(CURRENT_DIR)
	logFile = open(logFileName+'.log','w')

	#Change to directory
	os.chdir(CURRENT_DIR)

	#Walk along each first level folder in directory
	for dirname, dirnames, filenames in os.walk('.'):
		print dirname
		for subdirname in dirnames:
			#Basename of the current directory
			dirnameTitle = os.path.basename(subdirname)

			#Get all files under first level folder
			filesToSave = fileTree(subdirname,'')

			#Save files to playlist, using top-most folder
			saveFilesToPlaylist(filesToSave,subdirname,dirnameTitle,CURRENT_DIR)

			#Add playlist to log
			logFile.write(os.path.join(CURRENT_DIR,dirnameTitle,dirnameTitle+PLAYLIST_ID_TAG)+'\n')

		#Break the loop so we don't crawl through subdirectories and add playlists there
		break

	#Close connection to log file
	logFile.close()

#We are in main, run
if __name__ == '__main__':
	main()
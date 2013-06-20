#!/bin/bash

# biafra ahanonu
# updated: 2013.06.20
# latex_boilerplate
# this uses globals to get around the issue of passing variables between the different functions, to be fixed at some point.

# turn off echoing of commands
set +v

# welcome
welcome(){
	echo "latex_boilerplate builder v1.0"
	echo "biafra ahanonu"
	separator
}
separator(){
	# standardize separator output...
	echo "---------------------"
}
getDir(){
	# ask user for directory
	if [[ -z $texType ]]; then
		read -p "html or pdf? " texType
	fi
	# if [[ ! "pdfhtml" == *$texType* ]]; then
	# 	echo 'incorrect input, try again.'
	# 	getDir
	# fi
	if [[ -z $usrDir ]]; then usrDir=$texType; fi
	read -p "directory? " -i $usrDir -e usrDir
	cd $usrDir
	echo $( pwd )
	separator
}
getTexCompiler(){
	# change tex based on directory, use associative arrays
	declare -A texlist
	texlist=([html]=htlatex [pdf]=xelatex)
	# change tex based on directory
	tex=${texlist[$texType]}
}
getDefaultValues(){
	# defaults
	# tex=xelatex
	if [[ -z $renewdefaults ]]; then
		output="-interaction=batchmode"
		boutput="--quiet"
		rerun=1
		viewpdf=0
		dcheck=1
		texoutput=0
		savefiles="(*.pdf|*.log|*.tex|*.html|*.bbl|*.png|*.dvi|*.css)"
		# get name of tex file
		projectfile=$( find *.tex )
		#Remove extension
		project=${projectfile%.*}
		# retain ext: ${PROJECTT##*.}
	fi
}
displayDefaultValues(){
	echo "current settings"
	echo "yes[1], no[0]"
	echo "latex compiler: $tex"
	echo "latex output? $output"
	echo "bibtex output? $boutput"
	echo "rerun batch? $rerun"
	echo "show pdf? $viewpdf"
	echo "project file: $projectfile"

	read -p "settings work? yes[1] or no[0]: " -i $dcheck -e dcheck
	if [[ $dcheck == 0 ]]; then
		separator
		setDefaultValues
	fi
}
setDefaultValues(){
	# ask user for new default values, -i $variable allows display of a default value
	read -p "name of TEX file to compile? " -i $projectfile -e projectfile
	project=${projectfile%.*}
	read -p "xelatex[1] pdflatex[2] htlatex[3]? " -i 1 -e tex
	declare -A texlist
	texlist=([1]=xelatex [2]=pdflatex [3]=htlatex)
	tex=${texlist[$tex]}
	echo $tex
	read -p "Output? yes[1] or no[0]: " -i $texoutput -e texoutput
	declare -A outputlist; declare -A boutputlist;
	outputlist=([1]= [0]="-interaction=batchmode")
	boutputlist=([1]= [0]="--quiet")
	output=${outputlist[$texoutput]}
	boutput=${boutputlist[$texoutput]}
	# re-display values
	separator
	# clear
	displayDefaultValues
}
removeTempFiles(){
	separator
	#If temp files exist, delete them
	echo "cleaning up $project.* files..."
	find . -name "*.aux" -delete
	# find . -type f -name "index.*" -not -name "*.tex" -not -name "*.html"
	for file in `find $project.* | egrep -v $savefiles`; do
		rm -f $file
	done
}
buildHtmlFile(){
	separator
	echo $tex $projectfile
	# compile references
	echo "building references"
	for (( build = 0; build <= 2; build++ )); do
		latex $output $project >> $project.logs
		bibtex $boutput $project >> $project.logs
	done
	# set htlatex options, now set in packages.tex
	# fn-in puts footnotes at the end in the main html file
	htmlops="html,imgdir:images/,fn-in"
	htmlops2=""
	echo "$tex $project.tex $htmlops $htmlops2"
	# "xhtml,fn-in,imgdir:images/"" -cunihtf -utf8"
	# loop over and build several times to get all regs right
	for (( build = 0; build <= 2; build++ )); do
		separator
		echo "build #$build"
		if [[ $build == 1 ]]; then
			echo "\def\filename{{$project}{idx}{4dx}{ind}} \input extra/idxmake.4ht " > zindex.tex
			tex zindex.tex
			rm zindex.*
			makeindex -o ${project}.ind ${project}.4dx
		fi
		if [[ $tex == 'htlatex' ]]; then tex='ht latex';fi
		if [[ $texoutput == 1 ]]; then
			$tex $project.tex
		elif [[ $texoutput == 0 ]]; then
			$tex $project.tex >> $project.logs
		fi
	done
}
buildPdfFile(){
	#Compile several times to get all references/links correct
	separator
	echo "$tex --enable-installer $output ${project}.tex /wait"
	for (( build = 0; build <= 2; build++ )); do
		separator
		echo "build #$build"
		$tex --enable-installer $output ${project}.tex /wait
		bibtex $boutput $project
		makeindex ${project}.idx
	done
}
viewFinalProject(){
	#Open project file
	if [[ $viewpdf == 1 ]]; then
		echo Opening ${projectfile}...
		${projectfile}
	fi
}
askRerunScript(){
	# ask if user wants to rerun the script
	separator
	read -p "rerun script? yes[1] or no[0]: " -i $rerun -e rerun
	if [[ $rerun == 1 ]]; then
		renewdefaults=0
		main
	fi
}
main(){
	# main function
	welcome

	# get directory information
	getDir

	# decide on the tex compiler
	getTexCompiler

	# get program default values
	getDefaultValues

	# show user default values
	displayDefaultValues

	# remove temporary files before building
	removeTempFiles

	# build file
	if [[ $texType == "pdf" ]]; then buildPdfFile; fi
	if [[ $texType == "html" ]]; then buildHtmlFile; fi

	# remove temporary files
	removeTempFiles

	# show user results
	viewFinalProject

	# ask user to rerun the script
	askRerunScript
}

# run the script
main
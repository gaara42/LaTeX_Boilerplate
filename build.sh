#!/bin/bash

# biafra ahanonu
# updated: 2013.04.30
# latex_boilerplate

#Turn off echoing of commands
set +v

#Welcome
echo "latex_boilerplate builder v1.0"
echo "_______"

::defaults
tex=xelatex
output="-interaction=batchmode"
boutput="--quiet"
rerun=1
viewpdf=0
dcheck=1
checkout=1

#Ask user for name of project file
echo "name of TEX file to compile? "
read PROJECTT  
#Remove extension
PROJECTLEN=${#PROJECTT}-4
PROJECT=${PROJECTT:0:PROJECTLEN}
echo $PROJECT

#Ask for version of (xe)latex to use
echo "xelatex[1] pdflatex[2] htlatex[3]? "
read TEX
if [ "$TEX" == 1 ]; then TEX="xelatex"; fi
if [ "$TEX" == 2 ]; then TEX="pdflatex"; fi
echo "Output? yes[1] or no[0]: "
read OUTPUT
if [ "$OUTPUT" == 1 ]; then OUTPUT=[]; fi
if [ "$OUTPUT" == 0 ]; then OUTPUT="-interaction=batchmode"; fi

#If temp files exist, delete them
echo "cleaning up ${PROJECT}.* files..."
find project.* | egrep -v "(*.pdf|*.log|*.tex|*.html)" | rm
# echo "Checking for ${PROJECT}.aux"
# if [ -e ${PROJECT}.aux ]; then
	# rm ${PROJECT}.aux ${PROJECT}.bbl ${PROJECT}.blg ${PROJECT}.log ${PROJECT}.out ${PROJECT}.pdf ${PROJECT}.toc
# fi

#Compile several times to get all references/links correct
echo "_______"
for (( i = 0; i <= 3; i++ )); do
	echo "_______"
	echo "build #$i"
	$TEX --enable-installer $OUTPUT ${PROJECT}.tex /wait
	bibtex ${PROJECT}
done

echo "cleaning up ${PROJECT}.* files..."
find project.* | egrep -v "(*.pdf|*.log|*.tex|*.html)" | rm

#Open project file
echo Opening ${PROJECT}.pdf...
${PROJECT}.pdf
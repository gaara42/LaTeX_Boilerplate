#!/bin/bash

#biafra ahanonu
#update: 2012.12.08
#LaTeX_Boilerplate

#Turn off echoing of commands
set +v

#Welcome
echo "LaTeX_Boilerplate Builder v1.0"
echo "_______"

#Ask user for name of project file
echo "name of TEX file to compile? "
read PROJECTT  
#Remove extension
PROJECTLEN=${#PROJECTT}-4
PROJECT=${PROJECTT:0:PROJECTLEN}
echo $PROJECT

#Ask for version of (xe)latex to use
echo "xelatex[1] or pdflatex[2]? "
read TEX
if [ "$TEX" == 1 ]; then TEX="xelatex"; fi
if [ "$TEX" == 2 ]; then TEX="pdflatex"; fi
echo "Output? yes[1] or no[2]: "
read OUTPUT
if [ "$OUTPUT" == 1 ]; then OUTPUT=[]; fi
if [ "$OUTPUT" == 2 ]; then OUTPUT="-interaction=batchmode"; fi

#If temp files exist, delete them
echo "Checking for ${PROJECT}.aux"
if [ -e ${PROJECT}.aux ]; then
	echo "Deleting for ${PROJECT}.*"
	rm ${PROJECT}.aux ${PROJECT}.bbl ${PROJECT}.blg ${PROJECT}.log ${PROJECT}.out ${PROJECT}.pdf ${PROJECT}.toc
fi

#Compile several times to get all references/links correct
echo "_______"
for (( i = 0; i <= 3; i++ )); do
	echo "_______"
	echo "build #$i"
	$TEX --enable-installer $OUTPUT ${PROJECT}.tex /wait
	bibtex ${PROJECT}
done

#Open project file
echo Opening ${PROJECT}.pdf...
${PROJECT}.pdf
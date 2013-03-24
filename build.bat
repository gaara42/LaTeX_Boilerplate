::biafra ahanonu
::update: 2013.03.17
::LaTeX_Boilerplate

::Turn off echoing of commands
@ECHO OFF
cls
::Welcome
ECHO LaTeX_Boilerplate Builder v1.0
ECHO biafra ahanonu
pwd
TITLE %CD%
ECHO _______

::Defaults
SET TEX=xelatex
SET OUTPUT="-interaction=batchmode"
SET BOUTPUT="--quiet"
SET RERUN=1
SET DPDF=2
SET DCHECK=1
::Get name of project TEX file from root
::for /f "delims=" %a in ('dir /B *.tex') do @set PROJECT=%a
dir /B *.tex>project.name
set /p PROJECTT= < project.name
del project.name

::Display and check defaults
ECHO 1=yes, 2=no
ECHO text file: %TEX%
ECHO latex output? %OUTPUT%
ECHO bibtex output? %BOUTPUT%
ECHO rerun batch? %RERUN%
ECHO show pdf? %DPDF%
ECHO project file: %PROJECTT%
::Remove extension
SET PROJECT=%PROJECTT:~0,-4%

SET /P DCHECK="Defaults work? yes[1] or no[2]: "

IF %DCHECK% EQU 2 (
	::Ask user for name of project file
	SET /P PROJECTT=name of TEX file to compile? 
	::Remove extension
	SET PROJECT=%PROJECTT:~0,-4%

	::Ask for version of (xe)latex to use
	SET /P TEX="xelatex[1] or pdflatex[2]? "
	IF %TEX% EQU 1 SET TEX=xelatex
	IF %TEX% EQU 2 SET TEX=pdflatex
	SET /P OUTPUT="Output? yes[1] or no[2]: "
	IF %OUTPUT% EQU 1 SET OUTPUT=""
	IF %OUTPUT% EQU 1 SET BOUTPUT=""
	IF %OUTPUT% EQU 2 SET OUTPUT="-interaction=batchmode"
	IF %OUTPUT% EQU 2 SET BOUTPUT="--quiet"
	SET /P DPDF="Display PDF? yes[1] or no[2]: "
)
::If temp files exist, delete them
REN %PROJECT%.tex temp.tex
IF EXIST %PROJECT%.log (
	DEL %PROJECT%.*
)
REN temp.tex %PROJECT%.tex

::Compile several times to get all references/links/indices correct
ECHO _______
SET /a build=0
:loop
IF %build%==3 GOTO END
ECHO build #%build%
%TEX% --enable-installer %OUTPUT% %PROJECT%.tex /wait
bibtex %BOUTPUT% %PROJECT%
makeindex %PROJECT%.idx
ECHO _______
SET /a build=%build%+1
GOTO LOOP
:end

::Remove all project files, save .tex and .pdf
REN %PROJECT%.tex temp.tex
REN %PROJECT%.pdf temp.pdf
REN %PROJECT%.log temp.log
IF EXIST %PROJECT%.aux (
	DEL %PROJECT%.*
)
REN temp.tex %PROJECT%.tex
REN temp.pdf %PROJECT%.pdf
REN temp.log %PROJECT%.log 

::Remove all .aux files
@ECHO ON
DEL /S *.aux
@ECHO OFF

::Open project file
IF %DPDF%==1 (
	ECHO Opening %PROJECT%.pdf...
	%PROJECT%.pdf
)

::pause
::Ask if user wants to rerun the script
SET /P RERUN=Rerun script? yes[1] or no[2]: 
IF %RERUN% EQU 1 build.bat
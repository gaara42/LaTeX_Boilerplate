::biafra ahanonu
::update: 2012.12.08
::LaTeX_Boilerplate

::Turn off echoing of commands
@ECHO OFF

::Welcome
ECHO LaTeX_Boilerplate Builder v1.0
ECHO _______

::Ask user for name of project file
SET /P PROJECTT=name of TEX file to compile? 
::Remove extension
SET PROJECT=%PROJECTT:~0,-4%

::Ask for version of (xe)latex to use
SET /P TEX=xelatex[1] or pdflatex[2]? 
IF %TEX% EQU 1 SET TEX=xelatex
IF %TEX% EQU 2 SET TEX=pdflatex
SET /P OUTPUT=Output? yes[1] or no[2]: 
IF %OUTPUT% EQU 1 SET OUTPUT=[]
IF %OUTPUT% EQU 2 SET OUTPUT="-interaction=batchmode"

::If temp files exist, delete them
IF EXIST %PROJECT%.aux (
	DEL %PROJECT%.aux %PROJECT%.bbl %PROJECT%.blg %PROJECT%.log %PROJECT%.out %PROJECT%.pdf %PROJECT%.toc
	)

::Compile several times to get all references/links correct
ECHO _______
SET /a build=0
:loop
IF %build%==3 GOTO END
ECHO build #%build%
%TEX% --enable-installer %OUTPUT% %PROJECT%.tex /wait
bibtex %PROJECT%
ECHO _______
SET /a build=%build%+1
GOTO LOOP
:end

::Open project file
ECHO Opening %PROJECT%.pdf...
%PROJECT%.pdf

pause
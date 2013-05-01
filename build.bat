::biafra ahanonu
::update: 2013.03.17
::latex_boilerplate

::turn off echoing of commands
@echo off
cls
::allow proper variable setting
setlocal enabledelayedexpansion
::welcome
echo latex_boilerplate builder v1.0
echo biafra ahanonu
::display current directory and title
pwd
title %cd%
echo _______

::defaults
set tex=xelatex
set output="-interaction=batchmode"
set boutput="--quiet"
set rerun=1
set dpdf=0
set dcheck=1
set checkout=1
::get name of project tex file from root
::for /f "delims=" %a in ('dir /b *.tex') do @set project=%a
dir /b *.tex>project.name
set /p projectt= < project.name
del project.name

:settings
::display and check defaults
echo current settings
echo yes[1], no[0]
echo latex compiler: %tex%
echo latex output? %output%
echo bibtex output? %boutput%
echo rerun batch? %rerun%
echo show pdf? %dpdf%
echo project file: %projectt%
::remove extension
set project=%projectt:~0,-4%

set /p dcheck="settings work? yes[1] or no[0]: "

if %dcheck% equ 0 (
	::ask user for name of project file
	set /p projectt=name of tex file to compile? 
	::remove extension
	set project=%projectt:~0,-4%

	::ask for version of (xe)latex to use
	set /p tex="xelatex[1] pdflatex[2] htlatex[3]? "
	if !tex! equ 1 set tex=xelatex
	if !tex! equ 2 set tex=pdflatex
	if !tex! equ 3 set tex=htlatex
	set /p checkout="output? yes[1] or no[0]: "
	if !checkout! equ 1 set output=""
	if !checkout! equ 1 set boutput=""
	if !checkout! equ 0 set output="-interaction=batchmode"
	if !checkout! equ 0 set boutput="--quiet"
	set /p dpdf="display pdf? yes[1] or no[0]: "

	cls
	goto settings
)
::if temp files exist, delete them
for /f %%a in ('dir /b ^| findstr /v "tex html pdf log" ^| findstr /r %project%') do del %%a

ren temp.tex %project%.tex
::compile several times to get all references/links/indices correct
echo _______
set /a build=0
echo %tex%
if %tex%==htlatex goto htmlout
if %tex%==pdflatex goto loop
if %tex%==xelatex goto loop

::htlatex section
:htmlout
echo %tex% %project%.tex
::switch for if user wants output
if %checkout% equ 1 %tex% %project%.tex 
if %checkout% equ 0 %tex% %project%.tex > html.log
goto end

::pdflatex and xelatex section
:loop
if %build%==3 goto end
echo build #%build%
%tex% --enable-installer %output% %project%.tex /wait
bibtex %boutput% %project%
makeindex %project%.idx
echo _______
set /a build=%build%+1
goto loop
:end

@echo on
echo cleaning up and deleting files...
::remove all project files, save the below
for /f %%a in ('dir /b ^| findstr /v "tex html pdf log" ^| findstr /r %project%') do del %%a
::remove all .aux files
del /s *.aux
@echo off
echo done with cleanup
echo _______

::open project file
if %dpdf%==1 (
	echo opening %project%.pdf...
	%project%.pdf
)

::ask if user wants to rerun the script
set /p rerun=rerun script? yes[1] or no[2]: 
if %rerun% equ 1 build.bat

::return expansion variable to normal
endlocal
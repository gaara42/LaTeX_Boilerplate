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
echo _____________________

::defaults
if not defined renewdefaults (
	set tex=xelatex
	set output="-interaction=batchmode"
	set boutput="--quiet"
	set rerun=1
	set dpdf=0
	set dcheck=1
	set checkout=1
	set savefiles="tex html pdf log png bbl dvi css"
	::get name of project tex file from root
	::for /f "delims=" %a in ('dir /b *.tex') do @set project=%a
	dir /b *.tex>project.name
	set /p projectt= < project.name
	del project.name
)

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

::prompt user for input, new settings
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
for /f %%a in ('dir /b ^| findstr /v %savefiles% ^| findstr /r %project%') do del %%a

::compile several times to get all references/links/indices correct
echo _____________________
set /a build=0
echo %tex%
if %tex%==htlatex goto htmlout
if %tex%==pdflatex goto pdfloop
if %tex%==xelatex goto pdfloop

::htlatex section
:htmlout
	echo %tex% %project%.tex
	::switch for if user wants output
	latex %output% %project%
	bibtex %boutput% %project%
	latex %output% %project%
	bibtex %boutput% %project%
	SET htmlops="html,imgdir:images/,fn-in"
	SET htmlops2=""
	::"xhtml,fn-in,imgdir:images/"" -cunihtf -utf8"
	:loophtml
		echo _____________________
		echo build #%build%
		if %build%==2 goto end
		if %build%==1 (
			echo '\def\filename{{%project%}{idx}{4dx}{ind}} \input C:/Users/B/software/Portable/MikTeX/tex/generic/tex4ht/idxmake.4ht ' > zindex.tex
			tex zindex.tex
			del zindex.*
			makeindex -o %project%.ind %project%.4dx
		)
		if %checkout% equ 1 %tex% %project%.tex %htmlops% %htmlops2% 
		if %checkout% equ 0 %tex% %project%.tex %htmlops% %htmlops2% > %project%.logs
		set /a build=%build%+1
	goto loophtml
::goto end

::pdflatex and xelatex section
:pdfloop
	if %build%==3 goto end
	echo _____________________
	echo build #%build%
	%tex% --enable-installer %output% %project%.tex /wait
	bibtex %boutput% %project%
	makeindex %project%.idx
	set /a build=%build%+1
goto pdfloop

::exit loops
:end

::remove all project files, save the below
echo _____________________
echo cleaning up and deleting files...
	@echo on
	for /f %%a in ('dir /b ^| findstr /v %savefiles% ^| findstr /r %project%') do del %%a
	::remove all .aux files
	del /s *.aux
	@echo off
	echo done with cleanup

::open project file
echo _____________________
if %dpdf%==1 (
	echo opening %project%.pdf...
	%project%.pdf
)

::ONLY FOR BRAIN
echo _____________________
::move pictures to image folder
for /f %%a in ('dir /b ^| findstr "png"') do move /Y %%a images/
::move all images to article folder
xcopy /S /Y images "../syscarut/articles/115/images"

::ask if user wants to rerun the script
echo _____________________
set /p rerun=rerun script? yes[1] or no[2]: 
if %rerun% equ 1 (
	set renewdefaults=0
	build.bat
)
::return expansion variable to normal
endlocal
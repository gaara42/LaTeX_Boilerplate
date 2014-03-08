::biafra ahanonu
::updated: 2013.06.19
::latex_boilerplate

::turn off echoing of commands
@echo off
cls
::define separaters
set largeDivider=_______________________________________________________________
set plusDivider=++++++++++++++++++
set miniDivider=_______
::allow proper variable setting
setlocal enabledelayedexpansion
::welcome
echo latex_boilerplate builder v1.0
echo biafra ahanonu
::ask user for directory
if not defined texType (
	set /p texType=html or pdf?
)
::change tex based on directory
if %texType%==html set tex=htlatex
if %texType%==pdf set tex=xelatex
::move to directory
if not defined usrDir (
	set /p usrDir=directory?
)
cd %usrDir%
::display current directory and title
pwd
title %cd%
echo %largeDivider%

::defaults
if not defined renewdefaults (
	::set tex=xelatex
	set output="-interaction=batchmode"
	set boutput="--quiet"
	set rerun=1
	set viewpdf=0
	set dcheck=1
	set checkout=0
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
echo show pdf? %viewpdf%
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
	if !checkout! equ 1 set output=
	if !checkout! equ 1 set boutput=
	if !checkout! equ 0 set output="-interaction=batchmode"
	if !checkout! equ 0 set boutput="--quiet"
	set /p viewpdf="display pdf? yes[1] or no[0]: "

	::clear screen and re-display settings
	cls
	goto settings
)

::if temp files exist, delete them
for /f %%a in ('dir /b ^| findstr /v %savefiles% ^| findstr /r %project%') do del %%a

::compile several times to get all references/links/indices correct
echo %largeDivider%
set /a build=1
echo %tex%
if %tex%==htlatex goto htmlout
if %tex%==pdflatex goto pdfloop
if %tex%==xelatex goto pdfloop

::htlatex section
:htmlout
	if %tex% == htlatex set tex=ht latex
	echo %tex% %project%.tex
	::switch for if user wants output
	echo %miniDivider%
	echo building bibtex...
	latex %output% %project%
	bibtex %boutput% %project%
	latex %output% %project%
	bibtex %boutput% %project%
	::set some options for htlatex, now set in packages.tex
	SET htmlops="html,imgdir:images/,fn-in"
	SET htmlops2=""
	::"xhtml,fn-in,imgdir:images/"" -cunihtf -utf8"
	:loophtml
		echo.
		echo %largeDivider%
		echo build #%build%
		if %build%==4 goto end
		if %build%==1 (
			::C:/Users/B/software/Portable/MikTeX/tex/generic/tex4ht/
			echo '\def\filename{{%project%}{idx}{4dx}{ind}} \input idxmake.4ht ' > zindex.tex
			tex zindex.tex
			del zindex.*
			makeindex -o %project%.ind %project%.4dx
		)
		if %checkout% equ 1 %tex% %project%.tex
		if %checkout% equ 0 %tex% %project%.tex > %project%.logs
		set /a build=%build%+1
	goto loophtml
::goto end

::pdflatex and xelatex section
:pdfloop
	if %build%==4 goto end
	echo %largeDivider%
	echo build #%build%
	%tex% --enable-installer %output% %project%.tex /wait
	echo %plusDivider%
	bibtex %boutput% %project%
	echo %plusDivider%
	makeindex %project%.idx
	set /a build=%build%+1
goto pdfloop

::exit loops
:end

::remove all project files, save the below
echo %largeDivider%
echo cleaning up and deleting files...
	@echo on
	for /f %%a in ('dir /b ^| findstr /v %savefiles% ^| findstr /r %project%') do del %%a
	::remove all .aux files
	del /s *.aux
	@echo off
	echo done with cleanup

::open project file
echo %largeDivider%
if %viewpdf%==1 (
	echo opening %project%.pdf...
	%project%.pdf
)

::ask if user wants to rerun the script
echo %largeDivider%
set /p rerun=rerun script? yes[1] or no[0]:
if %rerun% equ 1 (
	set renewdefaults=0
	build.bat
)

::return expansion variable to normal
endlocal
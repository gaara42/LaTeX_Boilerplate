# LaTeX Boilerplate

## Overview

* A LaTeX boilerplate: skeleton code that implements various commonly used features in LaTeX. Code is all commented and will be expanded to include more packages or other aspects of LaTeX. Organized into sections, beginners should be able to debug easier while more advanced users can use it as a basic setup to get the ball rolling.

## Features

* Functional LaTeX project, download and start typesetting right away. Tested and works with MiKTeX.
* Automated compiling via scripts for Windows (`build.bat`) and Unix (`build.sh`) users.
* Fully commented with explanations for more difficult to understand elements.
* Various new commands to allow standardization of figure style and other common formatting. 
	* Functional \newcommand example implemented with `pgfkeys`.
* BibTex example file and example citation usage inside main text.
* Index implemented with example indices implemented in text (i.e. `\index{}`)
* Automatic list creation, answer key code, and equation citation.
* Much more!

## Installation

### Git

Go to your personal LaTeX projects directory (or wherever) and clone the repository using the command below:

    git clone https://github.com/gaara42/LaTeX_Boilerplate

### Manual

* Download the files using the GitHub .zip download option
* Unzip the files and rename the folder to whatever name you want, references are relative only below the root folder.

### Dependencies

* LaTeX (e.g. [MikTeX](http://miktex.org/)). 
	* Make sure to have all packages updated.
* [Pandoc](http://johnmacfarlane.net/pandoc/installing.html) for conversion of files if need be

### Windows

* After installing LaTeX distribution of choice, need to add the folder (e.g. `\MikTeX\miktex\bin`) containing `pdflatex.exe`, `bibtex.exe`, `makeindex` and `xelatex.exe` to you `PATH` environment variable.

### Linux

* Install [MikTeX](https://help.ubuntu.com/community/MiktexPackageManager) or another LaTeX distribution.
* `pdflatex.exe`, `bibtex.exe`, `makeindex` and `xelatex.exe` should be callable from command-line automatically.

## Instructions

###Overview

* The project has been tested on MiKTeX 2.9 and compiles fine (`project.tex`). If there are errors, open an issue and let me know.
* Open `project.tex`, contains the main TeX mark-up and references to other files. `\include` is used to add other project files.

###Build

* User is prompted to choose whether you want output; suppressed using `-interaction=batchmode` for (xe)latex or `--quiet` for bibtex.
* Removes .aux and other files then builds with (xe)latex and bibtex. Opens .pdf afterwards.
* Windows: double-click `build.bat`. 
* Unix: open Terminal, cd to directory, and type `bash build.sh`.

###Shortcuts

* Sublime Text 2 shortcuts have been added to the `\extras\sublime_text` folder.

###Fonts

* `\common\packages.tex` contains packages used and settings to get particular fonts working, example include Helvetica and Futura.
* Under `\assets` is `FuturaStd-Book.otf`, which must be installed on the system to use xelatex for custom `Futura Std Book` font seen in `packages.tex`.

###Pre-loaded

* These files are loaded before `\begin{document}`.
* `common\packages.tex` contains all the packages to be loaded.
* `common\header.tex` contains fancyhdr and other header/footer specifiers.
* `common\codes.tex` contains the new commands. 
	* All commands are documented and also used within the example files (e.g. `chapters\chapter1.tex`).
	* `pgfkeys` is used to circumvent the 9-argument problem with \newcommand. 
* `common\thanks.tex` is for copyright, thanks and update date tracking.

###Main Body

* These files are loaded in `\begin{document}` environment.
* `\chapters\citations.tex` includes some citations to figures, tables, and code.
* `\chapters\code.tex` shows how to include code in document by referencing source file.
* `\chapters\equations.tex` has several example equations.
* `\chapters\fasta.tex` include a macro to simplify integration of FASTA sequences into documents.
* `\chapters\lists.tex` shows the use of `\lbpitemize`, a macro create to make list creation faster and use less lines.
* `\chapters\problems.tex` demonstrates several example problems and use of the `\answers` macro.
* `\appendix\figures.tex` contains example figures using the new figure commands.
* `\appendix\table.tex` contains a row-shaded table.
* `\images` has example images used in `\appendix\figures.tex` to create figures.
* `sections\section1.tex` is an example file to create a new section.

###Bibliography

* Bibliography implemented in BibTeX, more extensible than manually entering citations.
* Run BibTeX twice before running (Xe)LaTeX to have citations included (automatically done with build scripts).
* `citations\cited.bib` is the bibtex file, contains book, article, online and other example source citations.
* `citations\Citations.xlsx` is an Excel spreadsheet that allows quick formatting of sources into LaTeX format if source online doesn't provide .bib link.

###Index

* Index implemented using `makeidx` package and `makeindex`.
* `citations\index.tex` contains the TeX code to include in the main project file.
* `\lbpindex{term}{}` is the new command to help add `term` at specified position while also adding it to the index, e.g. `term\index{term}`.

###Conversion

* I have included batch files (bash scripts forthecoming) to easily convert HTML to LaTeX and vis-versa. More Batch/Bash scripts to come for other common conversions.
* Windows: make sure to include the `pandoc` directory (e.g. `C:\Program Files\Pandoc`) in your `PATH` environment variable.
* `convert\0HTMLtoLaTeX.bat` ask for an output file name and converts `convert\0HtoL.html` to a .tex file.
* `convert\0LaTeXtoHTML.bat` ask for an output file name and converts `convert\0LtoH.tex` to an .html file.

## Changelog

<!-- * TODO Improved organization of  -->
<!-- * TODO Added working example of latex conversion with pandoc -->
* Improved code listing function and added `\codecite` for referencing code within text. Added code to customize the listing output (to be `Code` instead of the more obscure `Listing`) (2013.04.04).
* Changed from `\ref` to `\autoref` for figure/table/equation citation to make entire link clickable (2013.04.02).
* Split each different example into its own chapter for easier maintenance. Should also make it easier for people to find and use examples. (2013.03.17)
* Added equation macro along with new command to include code bits directly in the project. Improved `build.bat` to allow for more defaults to be set, saving key presses. Improved page height and margin calculations. (2013.03.16)
* Demo of previous new features, improvement to `build.sh` to bring it up to date with `build.bat`. Added an example .eps file to show postscript integration works (2013.03.03).
* New functions to make list creation easier, improve the default `\href` function, \answer function for document-wide switching on/off of specific text (useful for answer keys), and much more. Improvement to multifig to allow better detection of different inputs and adjust formatting accordingly (2013.02.23).
* Added color to the figures and table titles, improved index formatting, provided example alternative titlepage, and expanded multi-figure function to accept 2-4 figures and adjust accordingly. Added defaults to batch file. Slightly changed organization of some tex files (see `titlepage.tex`). (2013.01.11)
* Improved table of contents referencing, added nested indexing example and function, and several new packages. (2013.01.10)
* Margins and text height/width are now relative rather than absolute, if page size changes, text should dynamically change as well. (2013.01.10)
* Updated readme (2012.12.23)
* Added index, redefined its layout and made new index command. (2012.12.22)
* Redefined references layout. (2012.12.21)
* Improved `build.bat` a bit, cleans up more files after building. (2012.12.21)
* Added working example of a table, including shaded rows. (2012.12.21)
* Improved a bit of the layout and commenting (2012.12.21)
* Added `build.sh` for Unix users and updated `build.bat` to support several options at the beginning. (2012.12.08)
* Updated bibliography to include international support, organization tweaks (2012.12.08)
* Added to GitHub (2012.12.02)

### In Development

* Clean-up code and comments, add additional LaTeX features.
* Addition of conditional statement to figure to dynamically generate different multi-panel figures.
* Bash scripts for pandoc conversion.

##License

Biafra Ahanonu <bahanonu@gmail.com>

This program is free software: you can redistribute it and/or modify it under the terms of the [GNU](http://www.gnu.org/licenses/gpl.html). Attribution is appreciated, but not required, if parts of the software are used elsewhere.
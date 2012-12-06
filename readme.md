# LaTeX Boilerplate

## Overview

* A LaTeX boilerplate that contains an basic project setup that outlines various features in LaTeX. Code is all commented and will be expanded to include more packages or other aspects of LaTeX. Organized into sections, beginners should be able to debug easier while more advanced users can use it as a quick basic setup to get the ball rolling.

## Features

* Functional LaTeX project, download and start typesetting right away. Tested and works with MiKTeX.
* Fully commented with explanations for more difficult to understand elements.
* Various new commands to allow standardization of figure style and other common formatting. 
	* Functional \newcommand example implemented with `pgfkeys`.
* BibTex example file and example citation usage inside main text.

## Changelog

### What's New

* Added to GitHub (2012.12.02)

### In Development

* Clean-up code and comments, add additional LaTeX features.
* Addition of conditional statement to figure to dynamically generate different multi-panel figures.
* Bash scripts for pandoc conversion.

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

* After installing LaTeX distribution of choice, need to add the folder containing `latex.exe`, `bibtex.exe`, and `xelatex.exe` to you `PATH` environment variable.

### Linux

* `xelatex` and `latex` should automatically be added.

## Instructions

###Overview

* The project has been tested on MiKTeX 2.9 and compiles fine (compile `project.tex`). If there are errors, open a issue and let me know.
* Open `project.tex`, contains the main TeX mark-up and references to other files. `\Include` is used to add other project files.

###Build

* Windows: run `build.bat`. Removes .aux and other files then builds with (xe)latex and bibtex.

* Linux: run `build.sh` .Removes .aux and other files then builds with (xe)latex and bibtex.
	* Note, `build.sh` is not currently in the project, to be added soon!

###Pre-loaded

* These files are loaded before `\begin{document}`.
* `common\packages.tex` contains all the packages to be loaded.
* `common\codes.tex` contains the new commands. `pgfkeys` is used to circumvent the 9-argument problem with \newcommand. All commands are documented and also used within the example files (e.g. `chapters\chapter1.tex`).
* `common\thanks.tex` is for copyright or other 'thanks' pages.

###Main Body

* These files are loaded in `\begin{document}` environment.
* `chapters\chapter1.tex` is an example main text. Includes some citations and figures.
* `chapters\figures.tex` contains several figures.
* `images\` has example images used in `chapters\chapter1.tex` and `chapters\figures.tex` to create figures.
* `sections\section1.tex` is an example file to create a new section.

###Bibliography

* Bibliography implemented in BibTeX, more extensible than manually entering citations.
* Run BibTeX twice before running (Xe)LaTeX to have citations included.
* `citations\cited.bib` is the bibtex file, contains book, article, online and other example source citations.
* `citations\Citations.xlsx` is an Excel spreadsheet that allows quick formatting of sources into LaTeX format if source online doesn't provide .bib link.

###Conversion

* I have included Batch files (bash scripts forthecoming) to easily convert HTML to LaTeX and vis-versa. More Batch/Bash scripts to come for other common conversions.
* Windows users: make sure to include pandoc in your `PATH` environment variable.
* `convert\0HTMLtoLaTeX.bat` ask for an output file name and converts `convert\0HtoL.html` to a .tex file.
* `convert\0LaTeXtoHTML.bat` ask for an output file name and converts `convert\0LtoH.tex` to an .html file.

##License

Copyright (C) 2012 Biafra Ahanonu <bahanonu@gmail.com>

This program is free software: you can redistribute it and/or modify it under the terms of the [GNU](http://www.gnu.org/licenses/gpl.html). Attribution is appreciated, but not required, if parts of the software are used elsewhere.
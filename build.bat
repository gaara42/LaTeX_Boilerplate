DEL project.aux
DEL project.bbl
DEL project.blg
DEL project.log
DEL project.out
DEL project.pdf
DEL project.toc
xelatex --enable-installer project.tex /wait
bibtex project
xelatex --enable-installer project.tex /wait
bibtex project
xelatex --enable-installer project.tex /wait
bibtex project
project.pdf
pause
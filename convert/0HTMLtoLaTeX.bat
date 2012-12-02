@echo on
SET /P Hello=Tex?
pandoc -o %Hello%.tex 0HtoL.html
del *.aux
pause
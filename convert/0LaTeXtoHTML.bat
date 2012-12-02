@echo on
SET /P Hello=Tex?
pandoc -o %Hello%.html 0LtoH.tex
del *.aux
pause
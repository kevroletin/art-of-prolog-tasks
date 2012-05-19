author  := КевролетинВВ_задание_
pdf_dir := pdf

all : 01.pdf 02.pdf 03.pdf 04.pdf 05.pdf 06.pdf 07.pdf 08.pdf 09.pdf 10.pdf 11.pdf 12.pdf 13.pdf 14.pdf 15.pdf 16.pdf 17.pdf 18.pdf 19.pdf 20.pdf 21.pdf 22.pdf 23.pdf

%.pdf : %.org
	@echo $^ " -> " $@ " -> " $(pdf_dir)/$(author)$@
	emacs -batch -l ~/.emacs.d/user.el --visit=$^ --funcall org-export-as-pdf
	cp $@ $(pdf_dir)/$(author)$@

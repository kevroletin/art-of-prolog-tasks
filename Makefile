author  := КевролетинВВ_задание_
pdf_dir := pdf

all : 01.pdf 02.pdf 03.pdf 04.pdf 05.pdf 06.pdf 07.pdf 08.pdf 09.pdf 10.pdf 11.pdf 12.pdf 13.pdf 14.pdf 15.pdf 16.pdf 17.pdf 18.pdf 19.pdf 20.pdf 21.pdf 22.pdf ai_01.pdf ai_03.pdf ai_04.pdf ai_05.pdf ai_06.pdf ai_07.pdf ai_08.pdf ai_additional.pdf

%.pdf : %.org
	@echo $^ " -> " $@ " -> " $(pdf_dir)/$(author)$@
	emacs -batch -l ~/.emacs.d/user.el --visit=$^ --funcall org-export-as-pdf
	cp $@ $(pdf_dir)/$(author)$@

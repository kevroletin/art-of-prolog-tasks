author  := КевролетинВВ_задание_
pdf_dir := pdf

all : 1.pdf

%.pdf : %.org
	@echo $^ " -> " $@ " -> " $(pdf_dir)/$(author)$@
	emacs -batch -l ~/.emacs.d/user.el --visit=$^ --funcall org-export-as-pdf
	cp $@ $(pdf_dir)/$(author)$@

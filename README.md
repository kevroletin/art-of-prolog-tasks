
To produce \*.pdf from \*.org files you need emacs and latex installed
in your system.
\*.org files contains source code and russian letters, so you need to include
some latex packages, you can do in like this (add to your .emacs):

    ;; requite org-latex so that the following variables are defined
    (require 'org-latex)
    
    (setq org-export-latex-listings t)
    
    (add-to-list 'org-export-latex-packages-alist '("" "listings"))
    (add-to-list 'org-export-latex-packages-alist '("" "color"))
    (add-to-list 'org-export-latex-packages-alist '("russian" "babel"))
    (add-to-list 'org-export-latex-packages-alist '("T2A" "fontenc"))
    (add-to-list 'org-export-latex-packages-alist '("utf8" "inputenc"))
    (set-variable 'org-src-fontify-natively t)


Look into Makefile to find example how to run emacs in batch mode to produce
*.pdf files.

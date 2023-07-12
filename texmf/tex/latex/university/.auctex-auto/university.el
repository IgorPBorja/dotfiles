(TeX-add-style-hook
 "university"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fp" "nomessages")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "blindtext"
    "ragged2e"
    "amsmath"
    "amsthm"
    "amssymb"
    "amsfonts"
    "geometry"
    "changepage"
    "url"
    "physics"
    "hyperref"
    "cleveref"
    "tikz"
    "float"
    "pgffor"
    "fp"
    "enumitem")
   (TeX-add-symbols
    '("init" ["argument"] 0)
    '("n" ["argument"] 0)
    '("ufbaHeadline" 2)
    '("uniHeadline" 4)
    '("pset" 1)
    '("closure" 1)
    '("grule" 2)
    "derives"
    "wordto"
    "B"
    "N"
    "Z"
    "Q"
    "R"
    "C"
    "K"
    "orb"
    "SF"
    "diam"
    "sub"
    "Fm"
    "Mod"
    "mdc"
    "mmc"
    "sepline"
    "maketitleNobreak"
    "nodate"
    "var"
    "newpage")
   (LaTeX-add-environments
    '("grammar" 1)
    "solution"
    "tikzhere")
   (LaTeX-add-amsthm-newtheorems
    "problem"
    "lemma"
    "definition"
    "theorem"
    "corollary"
    "claim"
    "example"
    "note"))
 :latex)


;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Igor Borja"
      user-mail-address "igorpradoborja@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; 0: Global stuff

;; 0.1
;; goto line end with C-d (ON INSERT MODE)
(global-set-key '[remap evil-shift-left-line] 'doom/forward-to-last-non-comment-or-eol)

;; 0.2
;; set word wrap globally (for every buffer - file open) and persistently
(global-visual-line-mode 1)

;; 0.3
;; set larger font (but same typeface): from 10 to 14
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-22"))

; 0.4
;; remap terminal creation to C-T
;; (originally mapped to new workspace)
;;
(defun run_terminal ()
  "Open terminal and switch to it"
  (interactive)
  (split-window-right)
  (other-window 1)
  (vterm)
)

(global-set-key '[remap +workspace/new] 'run_terminal) ;;'split-window-right 'other-window )

;; 0.5
;; load yasnippet globally
;; https://emacs.stackexchange.com/questions/16742/how-to-install-setup-yasnippet-for-buffer-local-usage/16743#16743
;; (package-initialize)
;; ;; or, instead of using `package-initialize`, use the following:
;; ;; (add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-0.8.0/")
;; (require 'yasnippet)
;; ;; Using my custom location (since i'm using doomemacs)
;; (setq yas-snippet-dirs '("~/.config/doom/snippets"))
;; (yas-reload-all)

;; 1: TeX configurations

;; set default master file as main.tex in
;; multifile TeX projects
;; (setq-default TeX-master "main") ; All master files called "main"

;; deactivate subscripts and superscripts visual effect in TeX mode
(setq tex-fontify-script nil)
(setq font-latex-fontify-script nil)

;; define, inside the latex mode keymap,
;; 1. a keybinding M-p (that will be active when in latex mode) for updating the preview pane
(add-hook 'latex-mode-hook
          '(lambda()
             (define-key latex-mode-map "\M-p" 'latex-preview-pane-update)
             )
)
;; syntax
;; (add-hook '<hook>
;;      '(lambda()
;;              (define-key <map1> <keybinding1> '<event1>)
;;              ...
;;      )
;; )

;; 2. a keybiding C-RET (that will be active when in latex mode) for starting the preview pane in the next window
;; see https://emacsdocs.org/docs/elisp/Remapping-Commands
(add-hook 'latex-mode-hook
  '(lambda()
        (define-key latex-mode-map [remap +default/newline-below] 'latex-preview-pane-mode)
     )
  )

;; global equivalent
;; (global-set-key '[remap +default/newline-below] 'latex-preview-pane-mode)
;; this is because C-RET was originally bound to "+default/newline-below" (go to insertion mode and add newline).

;; The general syntax to set a key from command A to execute command B instead is
;; 1. Inside a mode/hook
;; (add-hook '<hook>
;;      '(lambda()
;;              (define-key <map> '[remap <commandA>] '<commandB>)
;;      )
;; )
;; 2. Globally
;; (global-set-key '[remap <commandA>] '<commandB>)

;; 2. C++ configurations
;; tab = 4 spaces for indentation in C mode (.c and .cpp, .h and .hpp)
(setq c-basic-offset 4)


;; 3. Java configurations
;; lsp
(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;; 4. Markdown configuration

(defun pandoc ()
  "Run pandoc on markdown file generating pdf with the same name"
  (interactive)
  (shell-command
    (concat
      "pandoc "
      buffer-file-name
      " -o "
      (file-name-with-extension buffer-file-name ".pdf")
      )
    )
  )

(add-hook 'markdown-mode-hook
          '(lambda()
             (define-key markdown-mode-map [remap +default/newline-below] 'pandoc)
             )
)


;; 5. UNDO/REDO
(global-set-key [remap evil-emacs-state] 'undo-only)
(global-set-key [remap evil-paste-from-register] 'undo-fu-only-redo)
;; unmap u (dangerous undo) (ONLY in normal mode, otherwise cant insert u)
;;
;;(require 'evil)

;; (global-set-key [+remap evil-emacs-state] undo-fu-only-undo)

;; 6. Emacs-lisp config
(setq lisp-body-indent 2)
(setq lisp-indent-offset 2)

;; 7. Jupyter notebooks
;; https://emacs.stackexchange.com/questions/42389/integrating-jupyter-notebook-ipython-into-org-mode-notebook
;; https://github.com/emacs-jupyter/jupyter
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

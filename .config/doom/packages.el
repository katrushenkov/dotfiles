;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! deadgrep)
(package! org-contacts)
(package! org-super-agenda)
(package! org-modern-indent
  :recipe (:host github :repo "jdtsmith/org-modern-indent"))
;; :files override needed: the MELPA recipe omits kubel-evil.el, which
;; remaps keys that clash with evil motion state (e.g. delete is "d" not
;; "k", since "k" moves up).
(package! kubel
  :recipe (:files (:defaults "kubel-evil.el")))

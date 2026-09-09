;;; $DOOMDIR/+omarchy.el -*- lexical-binding: t; -*-
;;
;; Keeps Doom's colors and font in sync with the current Omarchy system theme.
;;
;; How it fits together:
;;
;;   omarchy theme set X
;;     -> regenerates ~/.local/state/omarchy/current/theme/omarchy-colors.el
;;     -> runs ~/.config/omarchy/hooks/theme-set.d/omarchy-emacs
;;        -> omarchy-restart-emacs
;;           -> emacsclient: reload ~/.config/emacs/omarchy.el, then call
;;              (omarchy-apply-theme) and (omarchy-apply-font) in every frame
;;
;; The upstream integration (the omarchy-emacs package) applies its own plain
;; `omarchy' theme and sets the default face font directly. Under Doom that
;; fights `doom-theme' and `doom-font', so here we load upstream for its helper
;; functions and :override those two entry points with Doom-aware versions.
;; Advice lives on the symbol, so it survives upstream redefining the functions
;; when the hook reloads omarchy.el — the sync keeps working across upgrades.
;;
;; The actual colors come from $DOOMDIR/themes/omarchy-doom-theme.el.

(defvar +omarchy-shim-file (expand-file-name "~/.config/emacs/omarchy.el")
  "Path to the omarchy-emacs shim, which loads the packaged integration.")

(defvar +omarchy-theme 'omarchy-doom
  "Theme rebuilt from Omarchy's generated palette on every theme change.")


;;
;;; Load upstream (for its helpers) and neutralize what conflicts with Doom

(when (file-readable-p +omarchy-shim-file)
  ;; Loading this applies upstream's own theme/font once; our overrides below
  ;; immediately replace it, so only the daemon sees the intermediate state.
  (load +omarchy-shim-file nil 'nomessage))

(defun +omarchy--tidy ()
  "Undo upstream settings that Doom already handles better.
Re-run after every upstream reload, since loading omarchy.el re-adds them."
  ;; Doom's `:editor whitespace +trim' only trims lines you actually touched;
  ;; upstream's global hook rewrites unrelated lines in every file you save.
  (remove-hook 'before-save-hook #'delete-trailing-whitespace))


;;
;;; Theme

(defun +omarchy-colors-file ()
  "Return the path of Omarchy's generated Emacs palette, or nil."
  (when (boundp 'omarchy-theme-directory)
    (let ((file (expand-file-name "omarchy-colors.el" omarchy-theme-directory)))
      (and (file-readable-p file) file))))

(defun +omarchy-load-colors ()
  "Re-read Omarchy's generated palette into the `omarchy-color-*' variables."
  (when-let* ((file (+omarchy-colors-file)))
    ;; `load' (not `require') — the file is regenerated on every theme change.
    (load file nil 'nomessage)
    t))

(defun +omarchy-apply-theme (&rest _)
  "Reload Omarchy's palette and re-apply `doom-theme'.
Overrides `omarchy-apply-theme', so Omarchy's theme-set hook drives Doom."
  (interactive)
  (+omarchy-load-colors)
  (+omarchy--tidy)
  ;; Upstream's own shim calls the (at that point still unadvised)
  ;; `omarchy-apply-theme' unconditionally the moment it's loaded, above —
  ;; before this advice even exists to intercept it — which enables its own
  ;; plain `omarchy' theme. So `custom-enabled-themes' can't be trusted to
  ;; already hold `doom-theme': clear anything else out before (re)applying.
  (dolist (theme custom-enabled-themes)
    (unless (eq theme doom-theme)
      (disable-theme theme)))
  (if (custom-theme-enabled-p doom-theme)
      (doom/reload-theme)
    (load-theme doom-theme t)))


;;
;;; Font

(defun +omarchy-font-spec ()
  "Return a `font-spec' matching the font size/family Omarchy is using.
On pgtk builds, size is given in PIXELS: `omarchy display text size' folds its
scaling into both the terminal point size and GNOME's text-scaling-factor, and
pgtk would apply that factor a second time to a point size."
  (when (fboundp 'omarchy-current-font)
    (let ((family (string-trim (or (omarchy-current-font) "")))
          (pt (/ (omarchy-current-font-size) 10.0)))
      (unless (string-empty-p family)
        (if (featurep 'pgtk)
            (font-spec :family family :size (max 1 (round (* pt (/ 96.0 72.0)))))
          (font-spec :family family :size pt))))))

(defun +omarchy-apply-font (&rest _)
  "Point `doom-font' at Omarchy's font and reload it.
Overrides `omarchy-apply-font', so Omarchy's font-set hook drives Doom."
  (interactive)
  (when-let* ((spec (+omarchy-font-spec)))
    (setq doom-font spec
          doom-variable-pitch-font nil  ; inherit; Omarchy only defines one font
          doom-serif-font nil)
    (when after-init-time
      ;; A missing font signals `doom-font-error'; never let that break a
      ;; theme switch triggered from a hook.
      (ignore-errors (doom/reload-font)))))


;;
;;; Wire it up

(advice-add 'omarchy-apply-theme :override #'+omarchy-apply-theme)
(advice-add 'omarchy-apply-font  :override #'+omarchy-apply-font)

(setq doom-theme +omarchy-theme)

;; Make sure `omarchy-colors' is findable by the theme file even if upstream
;; is absent or its load-path setup changes.
(when (boundp 'omarchy-theme-directory)
  (add-to-list 'load-path omarchy-theme-directory))

;; Force our own theme/font now rather than trusting Doom's own startup
;; theme-loading to paper over upstream's eager self-applied `omarchy' theme
;; above — empirically it doesn't (once a theme is enabled, Doom's own
;; init-theme step is a no-op), so without this the daemon boots into plain
;; `omarchy' every time and only a manual (+omarchy-apply-theme) fixes it.
(+omarchy-apply-theme)
(+omarchy-apply-font)

;;; +omarchy.el ends here

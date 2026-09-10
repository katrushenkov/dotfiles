;;; omarchy-doom-theme.el --- Doom theme derived from Omarchy's palette -*- lexical-binding: t; -*-
;;
;; Built entirely from the colors Omarchy generates for the active system theme
;; (~/.local/state/omarchy/current/theme/omarchy-colors.el), so Emacs stays
;; color-coordinated with the terminal, the bar and everything else whenever
;; `omarchy theme set' runs.
;;
;; This file is ours (unlike ~/.config/emacs/themes/omarchy-theme.el, which the
;; omarchy-emacs package overwrites on every upgrade), so it is safe to edit.
;; It only depends on the generated `omarchy-colors' variables, which are a
;; stable contract of the omarchy theme system.
;;
;; Rebased 2026-09-09 on omarchy-emacs v1.10.1's own config/themes/omarchy-theme.el
;; (the previous copy here predated that rewrite by ~10 days and had drifted).
;; The derived-shade math below (omarchy-doom--pick/--readable/--contrast) is
;; ported from it near verbatim: prefer the shade a theme's author actually
;; chose (Omarchy 4's semantic `muted'/`selection'/`dark_foreground'/
;; `lighter_background' colors), blend one only when a theme doesn't carry
;; them or sets one equal to its own background, and push anything that
;; carries text up to a WCAG contrast floor instead of using it as-is.
;; Everything past that point — solaire/doom-modeline/evil/corfu/magit/etc
;; face coverage — has no upstream equivalent (upstream only styles plain
;; Emacs faces) and is what needs re-diffing by hand against a future
;; upstream release; the shade math itself should keep tracking upstream.
;;
;; Reloaded by `+omarchy-apply-theme' in $DOOMDIR/+omarchy.el.

(require 'cl-lib)
(require 'omarchy-colors)

(deftheme omarchy-doom
  "Doom theme synced with the current Omarchy system theme.")

(defgroup omarchy-doom nil
  "Doom theme synced from the current Omarchy theme."
  :group 'faces
  :prefix "omarchy-doom-")

(defun omarchy-doom--hex-rgb (color)
  "Return (R G B) as integers 0-255 for COLOR, or nil if it is not #RRGGBB."
  (when (and (stringp color)
             (string-match "\\`#\\([0-9a-fA-F]\\{6\\}\\)\\'" color))
    (let ((n (string-to-number (match-string 1 color) 16)))
      (list (ash n -16) (logand (ash n -8) 255) (logand n 255)))))

(defun omarchy-doom--blend (fg bg alpha)
  "Mix FG over BG at ALPHA, where 1.0 is all FG and 0.0 is all BG.
Falls back to FG when either color is not plain #RRGGBB hex."
  (let ((a (omarchy-doom--hex-rgb fg))
        (b (omarchy-doom--hex-rgb bg)))
    (if (and a b)
        (apply #'format "#%02x%02x%02x"
               (cl-mapcar (lambda (x y) (round (+ (* alpha x) (* (- 1.0 alpha) y))))
                          a b))
      fg)))

(defcustom omarchy-doom-contrast-floor-text 4.5
  "Minimum contrast ratio for chrome that carries text you read.
Applies to the inactive mode line and the header line."
  :type 'number :group 'omarchy-doom)

(defcustom omarchy-doom-contrast-floor-dim 3.0
  "Minimum contrast ratio for deliberately de-emphasized text.
Applies to comments, line numbers, and other faint chrome."
  :type 'number :group 'omarchy-doom)

(defun omarchy-doom--luminance (color)
  "WCAG relative luminance of COLOR, or nil if it is not #RRGGBB."
  (let ((rgb (omarchy-doom--hex-rgb color)))
    (when rgb
      (cl-loop for c in rgb
               for w in '(0.2126 0.7152 0.0722)
               sum (* w (let ((v (/ c 255.0)))
                          (if (<= v 0.03928)
                              (/ v 12.92)
                            (expt (/ (+ v 0.055) 1.055) 2.4))))))))

(defun omarchy-doom--contrast (a b)
  "WCAG contrast ratio between A and B, or 1.0 if either is unusable."
  (let ((la (omarchy-doom--luminance a))
        (lb (omarchy-doom--luminance b)))
    (if (and la lb)
        (/ (+ (max la lb) 0.05) (+ (min la lb) 0.05))
      1.0)))

(defun omarchy-doom--readable (fg bg floor)
  "FG pushed away from BG until it reaches FLOOR contrast.
Keeps the hue FG picked and walks it toward white or black, whichever BG is
not, only as far as legibility needs."
  (if (or (not (omarchy-doom--hex-rgb fg))
          (not (omarchy-doom--hex-rgb bg))
          (>= (omarchy-doom--contrast fg bg) floor))
      fg
    (let ((target (if (< (omarchy-doom--luminance bg) 0.5) "#ffffff" "#000000")))
      (cl-loop for step from 1 to 20
               for mixed = (omarchy-doom--blend target fg (* step 0.05))
               when (>= (omarchy-doom--contrast mixed bg) floor) return mixed
               finally return target))))

(defun omarchy-doom--pick (symbol fallback &optional distinct-from)
  "Value of SYMBOL when it is a usable #RRGGBB string, else FALLBACK.
A value is unusable when it is missing (an install whose color template
predates Omarchy 4's semantic block leaves the variable unbound) or when it
equals DISTINCT-FROM, which themes set `lighter_background'/`selection' to
often enough to matter, and which would leave the stripe or region invisible."
  (let ((v (and (boundp symbol) (symbol-value symbol))))
    (if (and (omarchy-doom--hex-rgb v)
             (not (and distinct-from (equal v distinct-from))))
        v
      fallback)))

(let* ((light  (if (fboundp 'omarchy-light-theme-p)
                   (omarchy-light-theme-p)
                 (or (file-exists-p "~/.local/state/omarchy/current/theme/light.mode")
                     (file-exists-p "~/.config/omarchy/current/theme/light.mode"))))
       (bg          omarchy-color-bg)
       (fg          omarchy-color-fg)
       (accent      omarchy-color-accent)
       (cursor      omarchy-color-cursor)
       (black       omarchy-color-black)
       (red         omarchy-color-red)
       (green       omarchy-color-green)
       (yellow      omarchy-color-yellow)
       (blue        omarchy-color-blue)
       (magenta     omarchy-color-magenta)
       (cyan        omarchy-color-cyan)
       (white       omarchy-color-white)
       (b-black     omarchy-color-bright-black)
       (b-red       omarchy-color-bright-red)
       (b-green     omarchy-color-bright-green)
       (b-yellow    omarchy-color-bright-yellow)
       (b-blue      omarchy-color-bright-blue)
       (b-magenta   omarchy-color-bright-magenta)
       (b-cyan      omarchy-color-bright-cyan)
       (b-white     omarchy-color-bright-white)
       ;; Derived shades. Prefer the shade the theme author actually chose
       ;; (Omarchy 4's semantic colors); blend one only when the theme doesn't
       ;; carry it or sets it equal to its own background; push anything that
       ;; carries text up to a WCAG contrast floor.
       (contrast    (if light "#000000" "#ffffff"))
       ;; No separate dimmed shade for non-file buffers (dashboard, ibuffer,
       ;; etc): actual omarchy has no such concept — everything is just
       ;; `bg' — and a 20%-toward-black blend (what this used to be, in both
       ;; the original file and my first "fix") reads as a plainly different,
       ;; wrong color rather than a subtle recede once you compare it side by
       ;; side with a file buffer.
       (bg-alt      bg)  ; solaire / sidebars — Doom-only, no upstream equivalent
       (bg-subtle   (omarchy-doom--pick 'omarchy-color-lighter-bg
                                        (omarchy-doom--blend fg bg 0.06) bg))  ; hl-line, popups
       (bg-lift     (omarchy-doom--pick 'omarchy-color-selection
                                        (omarchy-doom--blend fg bg 0.13) bg))  ; modeline, headers, selections
       (border      (omarchy-doom--pick 'omarchy-color-muted
                                        (omarchy-doom--blend fg bg 0.28) bg))
       ;; fg-dim: Doom-only concept (breadcrumb-weight text — buffer paths,
       ;; workspace tabs) with no upstream equivalent, so it gets the text
       ;; floor rather than upstream's dim floor.
       (fg-dim      (omarchy-doom--readable (omarchy-doom--blend fg bg 0.35)
                                            bg omarchy-doom-contrast-floor-text))
       (fg-faint    (omarchy-doom--readable
                     (omarchy-doom--pick 'omarchy-color-muted
                                         (omarchy-doom--blend fg bg 0.38) bg)
                     bg omarchy-doom-contrast-floor-dim))
       ;; The inactive mode line and header line sit on `bg-lift', not on the
       ;; buffer background, and carry the buffer name, so they get the text
       ;; floor against their own ground rather than the dim floor.
       (fg-chrome   (omarchy-doom--readable
                     (omarchy-doom--pick 'omarchy-color-muted
                                         (omarchy-doom--blend fg bg 0.38) bg-lift)
                     bg-lift omarchy-doom-contrast-floor-text))
       (comment     (omarchy-doom--readable
                     (omarchy-doom--pick 'omarchy-color-dark-fg
                                         (omarchy-doom--blend fg bg 0.52) bg)
                     bg omarchy-doom-contrast-floor-dim))
       ;; `colors.toml' is authoritative for the selection, but a few themes
       ;; set it equal to the background, which makes the region invisible.
       (sel-bg      (if (equal omarchy-color-sel-bg bg) bg-lift omarchy-color-sel-bg))
       (sel-fg      omarchy-color-sel-fg)
       (accent-bg   (omarchy-doom--blend bg accent 0.20))
       (green-bg    (omarchy-doom--blend bg green 0.18))
       (red-bg      (omarchy-doom--blend bg red 0.18))
       (yellow-bg   (omarchy-doom--blend bg yellow 0.18)))

  (custom-theme-set-faces
   'omarchy-doom

   ;;; Base
   `(default                    ((t (:foreground ,fg :background ,bg))))
   `(cursor                     ((t (:background ,cursor))))
   `(region                     ((t (:foreground ,sel-fg :background ,sel-bg :extend t))))
   `(secondary-selection        ((t (:background ,bg-lift :extend t))))
   `(highlight                  ((t (:background ,bg-lift))))
   `(hl-line                    ((t (:background ,bg-subtle :extend t))))
   `(fringe                     ((t (:foreground ,fg-faint :background ,bg))))
   `(shadow                     ((t (:foreground ,fg-faint))))
   `(vertical-border            ((t (:foreground ,border :background ,border))))
   ;; Blended into `bg', not `border': with the mode line now flattened to
   ;; `bg' too, a `border'-colored divider shows up as a stray rule right
   ;; under it (window-divider-mode draws one on every window). Same color as
   ;; the background keeps the divider functional (still there to drag) but
   ;; invisible, matching the flat look.
   `(window-divider             ((t (:foreground ,bg))))
   `(window-divider-first-pixel ((t (:foreground ,bg))))
   `(window-divider-last-pixel  ((t (:foreground ,bg))))
   `(internal-border            ((t (:background ,bg))))
   `(child-frame-border         ((t (:background ,border))))
   `(tooltip                    ((t (:foreground ,fg :background ,bg-alt))))
   `(trailing-whitespace        ((t (:background ,red-bg))))
   `(escape-glyph               ((t (:foreground ,b-cyan))))
   `(minibuffer-prompt          ((t (:foreground ,accent :weight bold))))
   `(header-line                ((t (:foreground ,fg-chrome :background ,bg-lift :box nil))))
   `(link                       ((t (:foreground ,cyan :underline t))))
   `(link-visited               ((t (:foreground ,magenta :underline t))))
   `(error                      ((t (:foreground ,red :weight bold))))
   `(warning                    ((t (:foreground ,yellow :weight bold))))
   `(success                    ((t (:foreground ,green :weight bold))))
   `(match                      ((t (:foreground ,accent :weight bold))))
   `(help-key-binding           ((t (:foreground ,accent :background ,bg-subtle))))
   `(fill-column-indicator      ((t (:foreground ,border))))

   ;;; Solaire (Doom dims non-file buffers)
   `(solaire-default-face          ((t (:foreground ,fg :background ,bg-alt))))
   `(solaire-hl-line-face          ((t (:background ,bg-subtle :extend t))))
   `(solaire-mode-line-face        ((t (:foreground ,fg :background ,bg-lift))))
   `(solaire-mode-line-inactive-face ((t (:foreground ,fg-faint :background ,bg-alt))))
   `(solaire-fringe-face           ((t (:background ,bg-alt))))
   `(solaire-header-line-face      ((t (:foreground ,fg :background ,bg-alt))))

   ;;; Line numbers
   `(line-number              ((t (:foreground ,fg-faint :background ,bg))))
   `(line-number-current-line ((t (:foreground ,accent :background ,bg-subtle :weight bold))))

   ;;; Mode line / doom-modeline
   ;; A solid bg-on-accent bar (upstream's own `mode-line' face, copied
   ;; verbatim) reads fine in a terminal, where `accent' is picked against a
   ;; near-black ANSI palette; against doom-modeline's much busier bar it went
   ;; illegible on several Omarchy themes where `accent' sits close in
   ;; luminance to `bg'. Flatten the bar to the buffer's own background
   ;; instead (this also lets frame `alpha-background' transparency read
   ;; through it like everywhere else), and tell active vs. inactive apart by
   ;; text color and the existing colored `doom-modeline-bar' stripe rather
   ;; than by filling the whole line.
   `(mode-line           ((t (:foreground ,fg :background ,bg :box nil))))
   `(mode-line-active    ((t (:foreground ,fg :background ,bg :box nil))))
   `(mode-line-inactive  ((t (:foreground ,fg-faint :background ,bg :box nil))))
   `(mode-line-emphasis  ((t (:foreground ,accent :weight bold))))
   `(mode-line-highlight ((t (:foreground ,bg :background ,accent))))
   `(mode-line-buffer-id ((t (:weight bold))))
   `(doom-modeline-bar             ((t (:background ,accent))))
   `(doom-modeline-bar-inactive    ((t (:background ,bg-alt))))
   `(doom-modeline-buffer-path     ((t (:foreground ,fg-dim))))
   `(doom-modeline-buffer-file     ((t (:foreground ,fg :weight bold))))
   `(doom-modeline-buffer-modified ((t (:foreground ,yellow :weight bold))))
   `(doom-modeline-buffer-major-mode ((t (:foreground ,accent :weight bold))))
   `(doom-modeline-project-dir     ((t (:foreground ,accent :weight bold))))
   `(doom-modeline-info            ((t (:foreground ,green))))
   `(doom-modeline-warning         ((t (:foreground ,yellow))))
   `(doom-modeline-urgent          ((t (:foreground ,red))))
   `(doom-modeline-debug           ((t (:foreground ,fg-faint))))
   `(doom-modeline-panel           ((t (:foreground ,bg :background ,accent))))
   `(doom-modeline-highlight       ((t (:foreground ,accent))))
   `(doom-modeline-evil-normal-state   ((t (:foreground ,accent :weight bold))))
   `(doom-modeline-evil-insert-state   ((t (:foreground ,green :weight bold))))
   `(doom-modeline-evil-visual-state   ((t (:foreground ,yellow :weight bold))))
   `(doom-modeline-evil-replace-state  ((t (:foreground ,red :weight bold))))
   `(doom-modeline-evil-operator-state ((t (:foreground ,cyan :weight bold))))
   `(doom-modeline-evil-motion-state   ((t (:foreground ,magenta :weight bold))))
   `(doom-modeline-evil-emacs-state    ((t (:foreground ,b-magenta :weight bold))))

   ;;; Workspaces (persp) indicators
   `(+workspace-tab-face          ((t (:foreground ,fg-dim :background ,bg))))
   `(+workspace-tab-selected-face ((t (:foreground ,bg :background ,accent :weight bold))))
   `(tab-bar                      ((t (:foreground ,fg-dim :background ,bg-alt))))
   `(tab-bar-tab                  ((t (:foreground ,fg :background ,bg :weight bold))))
   `(tab-bar-tab-inactive         ((t (:foreground ,fg-faint :background ,bg-alt))))
   `(tab-line                     ((t (:foreground ,fg-dim :background ,bg-alt))))

   ;;; Search
   `(isearch                ((t (:foreground ,bg :background ,yellow :weight bold))))
   `(isearch-fail           ((t (:foreground ,bg :background ,red :weight bold))))
   `(lazy-highlight         ((t (:foreground ,bg :background ,b-yellow))))
   `(evil-ex-search         ((t (:foreground ,bg :background ,yellow :weight bold))))
   `(evil-ex-lazy-highlight ((t (:foreground ,bg :background ,b-yellow))))
   `(evil-ex-substitute-matches     ((t (:foreground ,red :strike-through t))))
   `(evil-ex-substitute-replacement ((t (:foreground ,green :weight bold))))
   `(evil-goggles-default-face      ((t (:background ,accent-bg :extend t))))
   `(nav-flash-face                 ((t (:background ,accent-bg :extend t))))
   `(anzu-mode-line                 ((t (:foreground ,accent :weight bold))))

   ;;; Parens / delimiters
   `(show-paren-match    ((t (:foreground ,bg :background ,accent :weight bold))))
   `(show-paren-mismatch ((t (:foreground ,bg :background ,red :weight bold))))
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,accent))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,magenta))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,cyan))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,green))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,yellow))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,blue))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,b-magenta))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,b-cyan))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,b-green))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground ,red :weight bold))))
   `(highlight-indent-guides-character-face      ((t (:foreground ,border))))
   `(highlight-indent-guides-even-face           ((t (:background ,bg-subtle))))
   `(highlight-indent-guides-odd-face            ((t (:background ,bg))))
   `(highlight-indent-guides-top-character-face  ((t (:foreground ,accent))))
   `(indent-bars-face                            ((t (:foreground ,border))))

   ;;; Syntax
   `(font-lock-keyword-face       ((t (:foreground ,magenta))))
   `(font-lock-function-name-face ((t (:foreground ,blue))))
   `(font-lock-function-call-face ((t (:foreground ,blue))))
   `(font-lock-variable-name-face ((t (:foreground ,blue))))
   `(font-lock-variable-use-face  ((t (:foreground ,blue))))
   `(font-lock-string-face        ((t (:foreground ,green))))
   `(font-lock-comment-face       ((t (:foreground ,comment :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comment :slant italic))))
   `(font-lock-doc-face           ((t (:foreground ,b-green :slant italic))))
   `(font-lock-type-face          ((t (:foreground ,yellow))))
   `(font-lock-constant-face      ((t (:foreground ,white))))
   `(font-lock-builtin-face       ((t (:foreground ,cyan))))
   `(font-lock-preprocessor-face  ((t (:foreground ,red))))
   `(font-lock-warning-face       ((t (:foreground ,red :weight bold))))
   `(font-lock-number-face        ((t (:foreground ,white))))
   `(font-lock-negation-char-face ((t (:foreground ,red))))
   `(font-lock-operator-face      ((t (:foreground ,cyan))))
   `(font-lock-property-name-face ((t (:foreground ,cyan))))
   `(font-lock-property-use-face  ((t (:foreground ,cyan))))
   `(font-lock-punctuation-face   ((t (:foreground ,fg-dim))))
   `(font-lock-delimiter-face     ((t (:foreground ,fg-dim))))
   `(font-lock-bracket-face       ((t (:foreground ,fg-dim))))
   `(font-lock-escape-face        ((t (:foreground ,b-cyan))))

   ;;; hl-todo
   `(hl-todo ((t (:foreground ,red :weight bold))))

   ;;; Completion: vertico / corfu / orderless / marginalia / which-key
   `(vertico-current           ((t (:background ,bg-lift :extend t))))
   `(vertico-group-title       ((t (:foreground ,accent :weight bold))))
   `(vertico-group-separator   ((t (:foreground ,border :strike-through t))))
   `(corfu-default             ((t (:foreground ,fg :background ,bg-alt))))
   `(corfu-current             ((t (:foreground ,sel-fg :background ,sel-bg))))
   `(corfu-border              ((t (:background ,border))))
   `(corfu-bar                 ((t (:background ,accent))))
   `(corfu-annotations         ((t (:foreground ,fg-faint))))
   `(corfu-deprecated          ((t (:foreground ,fg-faint :strike-through t))))
   `(orderless-match-face-0    ((t (:foreground ,accent :weight bold))))
   `(orderless-match-face-1    ((t (:foreground ,magenta :weight bold))))
   `(orderless-match-face-2    ((t (:foreground ,green :weight bold))))
   `(orderless-match-face-3    ((t (:foreground ,yellow :weight bold))))
   `(completions-common-part      ((t (:foreground ,accent :weight bold))))
   `(completions-first-difference ((t (:foreground ,fg :weight bold))))
   `(completions-annotations      ((t (:foreground ,fg-faint :slant italic))))
   `(marginalia-key            ((t (:foreground ,accent))))
   `(marginalia-documentation  ((t (:foreground ,fg-faint :slant italic))))
   `(marginalia-file-priv-dir  ((t (:foreground ,blue))))
   `(marginalia-modified       ((t (:foreground ,yellow))))
   `(which-key-key-face                 ((t (:foreground ,accent :weight bold))))
   `(which-key-group-description-face   ((t (:foreground ,magenta))))
   `(which-key-command-description-face ((t (:foreground ,fg))))
   `(which-key-separator-face           ((t (:foreground ,fg-faint))))
   `(consult-file              ((t (:foreground ,fg-dim))))
   `(consult-preview-line      ((t (:background ,bg-subtle :extend t))))

   ;;; Checkers
   `(flycheck-error   ((t (:underline (:style wave :color ,red)))))
   `(flycheck-warning ((t (:underline (:style wave :color ,yellow)))))
   `(flycheck-info    ((t (:underline (:style wave :color ,green)))))
   `(flycheck-fringe-error   ((t (:foreground ,red))))
   `(flycheck-fringe-warning ((t (:foreground ,yellow))))
   `(flycheck-fringe-info    ((t (:foreground ,green))))
   `(flymake-error   ((t (:underline (:style wave :color ,red)))))
   `(flymake-warning ((t (:underline (:style wave :color ,yellow)))))
   `(flymake-note    ((t (:underline (:style wave :color ,green)))))
   `(compilation-error   ((t (:foreground ,red :weight bold))))
   `(compilation-warning ((t (:foreground ,yellow))))
   `(compilation-info    ((t (:foreground ,green))))

   ;;; VC gutter / diff-hl / git-gutter
   `(diff-hl-insert ((t (:foreground ,green :background ,green))))
   `(diff-hl-change ((t (:foreground ,yellow :background ,yellow))))
   `(diff-hl-delete ((t (:foreground ,red :background ,red))))
   `(git-gutter:added       ((t (:foreground ,green))))
   `(git-gutter:modified    ((t (:foreground ,yellow))))
   `(git-gutter:deleted     ((t (:foreground ,red))))
   `(git-gutter-fr:added    ((t (:foreground ,green))))
   `(git-gutter-fr:modified ((t (:foreground ,yellow))))
   `(git-gutter-fr:deleted  ((t (:foreground ,red))))

   ;;; Diff / ediff
   `(diff-added        ((t (:foreground ,green :background unspecified))))
   `(diff-removed      ((t (:foreground ,red :background unspecified))))
   `(diff-changed      ((t (:foreground ,yellow :background ,yellow-bg :extend t))))
   `(diff-header       ((t (:foreground ,cyan :weight bold))))
   `(diff-file-header  ((t (:foreground ,blue :weight bold))))
   `(diff-hunk-header  ((t (:foreground ,magenta :background ,bg-subtle :extend t))))
   `(diff-refine-added   ((t (:foreground ,bg :background ,green))))
   `(diff-refine-removed ((t (:foreground ,bg :background ,red))))
   `(ediff-current-diff-A ((t (:background ,red-bg :extend t))))
   `(ediff-current-diff-B ((t (:background ,green-bg :extend t))))
   `(ediff-even-diff-A    ((t (:background ,bg-subtle :extend t))))
   `(ediff-even-diff-B    ((t (:background ,bg-subtle :extend t))))
   `(ediff-odd-diff-A     ((t (:background ,bg-alt :extend t))))
   `(ediff-odd-diff-B     ((t (:background ,bg-alt :extend t))))

   ;;; Magit
   `(magit-section-heading       ((t (:foreground ,accent :weight bold))))
   `(magit-section-highlight     ((t (:background ,bg-subtle :extend t))))
   `(magit-section-secondary-heading ((t (:foreground ,magenta :weight bold))))
   `(magit-branch-local          ((t (:foreground ,cyan :weight bold))))
   `(magit-branch-remote         ((t (:foreground ,green :weight bold))))
   `(magit-branch-current        ((t (:foreground ,accent :weight bold :box nil))))
   `(magit-tag                   ((t (:foreground ,yellow))))
   `(magit-hash                  ((t (:foreground ,fg-faint))))
   `(magit-log-author            ((t (:foreground ,magenta))))
   `(magit-log-date              ((t (:foreground ,fg-faint))))
   `(magit-diff-added            ((t (:foreground ,green :background ,green-bg :extend t))))
   `(magit-diff-added-highlight  ((t (:foreground ,green :background ,(omarchy-doom--blend bg green 0.28) :extend t))))
   `(magit-diff-removed          ((t (:foreground ,red :background ,red-bg :extend t))))
   `(magit-diff-removed-highlight ((t (:foreground ,red :background ,(omarchy-doom--blend bg red 0.28) :extend t))))
   `(magit-diff-context          ((t (:foreground ,fg-dim :extend t))))
   `(magit-diff-context-highlight ((t (:foreground ,fg :background ,bg-subtle :extend t))))
   `(magit-diff-hunk-heading     ((t (:foreground ,fg-dim :background ,bg-lift :extend t))))
   `(magit-diff-hunk-heading-highlight ((t (:foreground ,bg :background ,accent :extend t))))
   `(magit-diff-file-heading     ((t (:foreground ,fg :weight bold))))
   `(magit-diff-file-heading-highlight ((t (:background ,bg-subtle :weight bold :extend t))))
   `(magit-blame-heading         ((t (:foreground ,fg :background ,bg-lift :extend t))))

   ;;; Dired
   `(dired-directory  ((t (:foreground ,blue :weight bold))))
   `(dired-header     ((t (:foreground ,accent :weight bold))))
   `(dired-symlink    ((t (:foreground ,cyan :slant italic))))
   `(dired-broken-symlink ((t (:foreground ,red :slant italic))))
   `(dired-marked     ((t (:foreground ,yellow :weight bold))))
   `(dired-flagged    ((t (:foreground ,red :weight bold))))
   `(dired-ignored    ((t (:foreground ,fg-faint))))

   ;;; Doom dashboard
   `(doom-dashboard-banner      ((t (:foreground ,fg-faint))))
   `(doom-dashboard-footer      ((t (:foreground ,accent))))
   `(doom-dashboard-footer-icon ((t (:foreground ,accent))))
   `(doom-dashboard-loaded      ((t (:foreground ,fg-faint))))
   `(doom-dashboard-menu-title  ((t (:foreground ,accent :weight bold))))
   `(doom-dashboard-menu-desc   ((t (:foreground ,magenta))))

   ;;; Org
   `(org-level-1        ((t (:foreground ,blue :weight bold :height 1.1))))
   `(org-level-2        ((t (:foreground ,magenta :weight bold))))
   `(org-level-3        ((t (:foreground ,cyan :weight bold))))
   `(org-level-4        ((t (:foreground ,yellow))))
   `(org-level-5        ((t (:foreground ,green))))
   `(org-level-6        ((t (:foreground ,blue))))
   `(org-level-7        ((t (:foreground ,b-magenta))))
   `(org-level-8        ((t (:foreground ,b-cyan))))
   `(org-document-title ((t (:foreground ,accent :weight bold :height 1.3))))
   `(org-document-info  ((t (:foreground ,fg-dim))))
   `(org-block          ((t (:background ,bg-subtle :extend t))))
   `(org-block-begin-line ((t (:foreground ,fg-faint :background ,bg-subtle :extend t))))
   `(org-block-end-line ((t (:foreground ,fg-faint :background ,bg-subtle :extend t))))
   `(org-code           ((t (:foreground ,green))))
   `(org-verbatim       ((t (:foreground ,white))))
   `(org-table          ((t (:foreground ,cyan))))
   `(org-link           ((t (:foreground ,cyan :underline t))))
   `(org-todo           ((t (:foreground ,red :weight bold))))
   `(org-done           ((t (:foreground ,green :weight bold))))
   `(org-headline-done  ((t (:foreground ,fg-faint))))
   `(org-date           ((t (:foreground ,b-blue :underline t))))
   `(org-drawer         ((t (:foreground ,fg-faint))))
   `(org-special-keyword ((t (:foreground ,magenta))))
   `(org-ellipsis       ((t (:foreground ,fg-faint :underline nil))))
   `(org-checkbox       ((t (:foreground ,accent :weight bold))))
   `(org-agenda-date          ((t (:foreground ,accent :weight bold))))
   `(org-agenda-date-today    ((t (:foreground ,yellow :weight bold))))
   `(org-agenda-structure     ((t (:foreground ,magenta :weight bold))))
   `(org-scheduled            ((t (:foreground ,green))))
   `(org-scheduled-today      ((t (:foreground ,b-green))))
   `(org-upcoming-deadline    ((t (:foreground ,yellow))))
   `(org-warning              ((t (:foreground ,red :weight bold))))

   ;;; Markdown
   `(markdown-header-face-1     ((t (:foreground ,accent :weight bold :height 1.15))))
   `(markdown-header-face-2     ((t (:foreground ,magenta :weight bold :height 1.08))))
   `(markdown-header-face-3     ((t (:foreground ,cyan :weight bold))))
   `(markdown-header-face-4     ((t (:foreground ,yellow :weight bold))))
   `(markdown-header-delimiter-face ((t (:foreground ,fg-faint))))
   `(markdown-markup-face       ((t (:foreground ,fg-faint))))
   `(markdown-code-face         ((t (:background ,bg-subtle :extend t))))
   `(markdown-inline-code-face  ((t (:foreground ,green :background ,bg-subtle))))
   `(markdown-pre-face          ((t (:foreground ,green))))
   `(markdown-link-face         ((t (:foreground ,cyan))))
   `(markdown-url-face          ((t (:foreground ,fg-faint :underline t))))
   `(markdown-list-face         ((t (:foreground ,accent))))
   `(markdown-blockquote-face   ((t (:foreground ,fg-dim :slant italic))))

   ;;; Terminals
   `(term-color-black   ((t (:foreground ,black :background ,black))))
   `(term-color-red     ((t (:foreground ,red :background ,red))))
   `(term-color-green   ((t (:foreground ,green :background ,green))))
   `(term-color-yellow  ((t (:foreground ,yellow :background ,yellow))))
   `(term-color-blue    ((t (:foreground ,blue :background ,blue))))
   `(term-color-magenta ((t (:foreground ,magenta :background ,magenta))))
   `(term-color-cyan    ((t (:foreground ,cyan :background ,cyan))))
   `(term-color-white   ((t (:foreground ,white :background ,white))))
   `(vterm-color-black   ((t (:foreground ,black :background ,b-black))))
   `(vterm-color-red     ((t (:foreground ,red :background ,b-red))))
   `(vterm-color-green   ((t (:foreground ,green :background ,b-green))))
   `(vterm-color-yellow  ((t (:foreground ,yellow :background ,b-yellow))))
   `(vterm-color-blue    ((t (:foreground ,blue :background ,b-blue))))
   `(vterm-color-magenta ((t (:foreground ,magenta :background ,b-magenta))))
   `(vterm-color-cyan    ((t (:foreground ,cyan :background ,b-cyan))))
   `(vterm-color-white   ((t (:foreground ,white :background ,b-white))))

   ;;; Misc packages
   `(popup-face            ((t (:foreground ,fg :background ,bg-alt))))
   `(popup-tip-face        ((t (:foreground ,fg :background ,bg-lift))))
   `(ansi-color-bright-black ((t (:foreground ,b-black :background ,b-black))))
   `(widget-field          ((t (:foreground ,fg :background ,bg-lift))))
   `(custom-variable-tag   ((t (:foreground ,accent :weight bold))))
   `(custom-group-tag      ((t (:foreground ,magenta :weight bold :height 1.2)))))

  (custom-theme-set-variables
   'omarchy-doom
   `(ansi-color-names-vector
     ,(vector black red green yellow blue magenta cyan white))))

(provide-theme 'omarchy-doom)
;;; omarchy-doom-theme.el ends here

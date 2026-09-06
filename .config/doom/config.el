;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(load! "private.el" doom-user-dir t)

;; Show the which-key popup almost immediately instead of waiting.
(setq which-key-idle-delay 0.0
      which-key-idle-secondary-delay 0.0)

(setq default-directory "~/.local/src/datagrip/")

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

;; ksm шрифт, чтобы нормально отображались файлы на винде
;;;;(setq doom-themes-enable-bold nil)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; Left nil: the Omarchy integration below drives theming live instead.
(setq doom-theme nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.local/src/datagrip/org/")
;;(setq org-directory "~/org/")

(use-package org-contacts
  :ensure nil
  :after org
  :custom (org-contacts-files '("~/.local/src/datagrip/org/contacts.org"))
  :config
  ;; org-contacts' "@Name" completion-at-point only activates in modes listed
  ;; here, checked against `major-mode' — org-journal-mode doesn't match even
  ;; though it's org-derived, so it silently never activated in journal
  ;; entries. Add it so you can type "@" + a contact's name in journal entries
  ;; too and complete it via corfu.
  (add-to-list 'org-contacts-completion-enabled-mode-list 'org-journal-mode))

(map! :leader
      (:prefix "n"
       :desc "Find contact" "b" #'org-contacts))

;; Files org-agenda scans for TODOs/SCHEDULED/DEADLINE items and
;; org-contacts birthdays. Directories are scanned for their top-level
;; *.org files (not recursive).
(setq org-agenda-files (list org-directory
                              "~/.local/src/datagrip/org/journal/"))

(map! :leader
      (:prefix "n"
       :desc "Open org index" "i" (cmd! (find-file (expand-file-name "index.org" org-directory)))
       (:prefix ("j" . "journal")
        :desc "New/today's entry" "j" #'org-journal-new-entry
        :desc "New entry on date" "d" #'org-journal-new-date-entry
        :desc "Search"            "s" #'org-journal-search
        :desc "Open calendar"     "c" #'calendar)))

;; Mirror org-journal's raw calendar-mode-map bindings (],[,j m/r/d/n — always
;; active once org-journal loads, regardless of leader keys) as a discoverable
;; localleader tree inside the calendar buffer itself.
(after! calendar
  (map! :map calendar-mode-map
        :localleader
        (:prefix ("j" . "journal")
         :desc "Mark entries"    "m" #'org-journal-mark-entries
         :desc "Read entry"      "r" #'org-journal-read-entry
         :desc "Display entry"   "d" #'org-journal-display-entry
         :desc "New date entry"  "n" #'org-journal-new-date-entry
         :desc "Next entry"      "]" #'org-journal-next-entry
         :desc "Previous entry"  "[" #'org-journal-previous-entry)))

;; More visual priority cookies via org-modern's own priority prettification
;; (NOT the org-fancy-priorities package — it fights with org-modern over the
;; same text, causing flicker). Commented out to go back to org-modern's
;; defaults (letters, brackets hidden, colored A=red/B=yellow/C=gray
;; inverse-video badges from the +pretty module). Uncomment to switch to
;; colored circle glyphs instead.
;;(after! org-modern
;;  (setq org-modern-priority
;;        '((?A . "🔴")
;;          (?B . "🟡")
;;          (?C . "🟢"))
;;        ;; The colored circle already carries the color; drop the inverse-video
;;        ;; red/yellow/gray background swatch that was there for the plain
;;        ;; letters, so it doesn't double up as a box behind the emoji.
;;        org-modern-priority-faces nil))

;; GTD-style context tags. @anima/@flant/@errand are mutually exclusive
;; (:startgroup/:endgroup); call/read are free-standing.
(setq org-tag-alist
      '((:startgroup)
        ("@anima" . ?a)
        ("@flant" . ?f)
        ("@errand" . ?e)
        (:endgroup)
        ("call" . ?c)
        ("read" . ?r)
        ("crypt" . ?x)))

;; org-crypt (+crypt flag in init.el): encrypt the body of any heading tagged
;; :crypt: with GPG on save, decrypt on demand. Only the entry's TEXT is
;; encrypted — the heading title and any properties stay in plaintext, so
;; don't put anything sensitive in the title itself.
(after! org-crypt
  (setq org-crypt-key "katrushenkov@gmail.com"))

(after! org
  (map! :map org-mode-map
        :localleader
        (:prefix ("x" . "crypt")
         :desc "Encrypt entry"              "e" #'org-encrypt-entry
         :desc "Decrypt entry"              "d" #'org-decrypt-entry
         :desc "Encrypt all entries in buffer" "E" #'org-encrypt-entries
         :desc "Decrypt all entries in buffer" "D" #'org-decrypt-entries)))

;; Pull org-contacts birthdays into the agenda via the classic diary sexp
;; mechanism (org-contacts has no native agenda integration of its own).
(setq diary-file (expand-file-name "diary" org-directory)
      org-agenda-include-diary t
      ;; org-agenda-include-diary also pulls in Emacs' generic (US/Christian/
      ;; etc.) holiday list by default — e.g. "Labor Day" showed up in agenda
      ;; unasked. All that was wanted here is org-contacts-anniversaries.
      calendar-holidays nil)

(setq org-agenda-custom-commands
      '(("d" "Day: agenda + active tasks"
         ((agenda "" ((org-agenda-span 1)))
          (todo "TODO|PROJ|STRT"
                ((org-agenda-overriding-header "Active tasks")))))
        ("h" "@anima tasks" tags-todo "@anima")
        ("w" "@flant tasks" tags-todo "@flant")
        ("e" "@errand tasks" tags-todo "@errand")
        ("r" "Review: week ahead + stuck items"
         ((agenda "" ((org-agenda-span 7)))
          (todo "WAIT" ((org-agenda-overriding-header "Waiting on")))
          (todo "PROJ" ((org-agenda-overriding-header "Projects")))))))

;; Desktop notifications for timed reminders. No separate file needed — any
;; heading with a SCHEDULED/DEADLINE timestamp that includes a time (e.g.
;; "SCHEDULED: <2026-09-06 Sun 15:00>"), anywhere in org-agenda-files, gets
;; picked up automatically: one notification, right at the time itself.
(use-package! appt
  :after org
  :config
  ;; appt-message-warning-time: how many minutes before the event the
  ;; "warning window" opens (0 = only right at the event, no advance notice).
  ;; appt-display-interval: while inside that window, how often (in minutes)
  ;; appt-check actually shows a notification (irrelevant here since the
  ;; window is 0 minutes wide, so there's only ever one moment to show).
  ;;
  ;; Alternative: warn N minutes ahead AND repeat every M minutes until the
  ;; event (stock appt.el behavior) — NOTE this repeat-interval is gated on a
  ;; counter shared across ALL pending appointments, confirmed live to
  ;; sometimes silently skip an individual appointment's exact "due now"
  ;; moment when phases don't line up (it's still removed from the queue
  ;; either way). Use interval 1 to avoid that (every minute, no gaps, but
  ;; more frequent pings):
  ;;(setq appt-message-warning-time 15
  ;;      appt-display-interval 1)
  ;;
  ;; Alternative: exactly two notifications — N minutes before, and at the
  ;; event itself, nothing in between (bypasses appt-display-interval
  ;; entirely; needs +org-appt-notify below rewritten to filter by the exact
  ;; minutes-remaining instead of firing unconditionally):
  ;;(setq appt-message-warning-time 10
  ;;      appt-display-interval 1)
  ;;(defun +org-appt-notify (min-to-app new-time appt-msg)
  ;;  (cl-loop for min in (ensure-list min-to-app)
  ;;           for msg in (ensure-list appt-msg)
  ;;           for mins = (if (stringp min) (string-to-number min) min)
  ;;           when (or (= mins 0) (= mins appt-message-warning-time))
  ;;           do (call-process "omarchy-notification-send" nil 0 nil
  ;;                            "--app-name" "Emacs" "-u" "normal" "-g" "󰢌"
  ;;                            "Напоминание" msg)))
  (setq appt-message-warning-time 0
        appt-display-interval 1
        appt-display-mode-line nil
        appt-audible nil)
  (defun +org-appt-notify (min-to-app new-time appt-msg)
    (dolist (msg (ensure-list appt-msg))
      (call-process "omarchy-notification-send" nil 0 nil
                    "--app-name" "Emacs" "-u" "normal" "-g" "󰢌"
                    "Напоминание" msg)))
  (setq appt-disp-window-function #'+org-appt-notify
        appt-delete-window-function #'ignore)
  (appt-activate 1)
  (defun +org-refresh-appt ()
    (org-agenda-to-appt t))
  (+org-refresh-appt)
  (run-at-time nil (* 10 60) #'+org-refresh-appt)
  (add-hook 'org-capture-after-finalize-hook #'+org-refresh-appt))

;; Regroups agenda entries into named sections instead of a flat list.
;; Purely a display layer over the agenda commands above — doesn't touch any
;; files. To turn it off again: delete this block and the `(package!
;; org-super-agenda)' line in packages.el, then `doom sync'.
(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups
        '((:name "Overdue" :deadline past :scheduled past)
          (:name "Today" :time-grid t :deadline today :scheduled today)
          (:name "High priority" :priority "A")
          (:name "Waiting" :todo "WAIT")
          (:name "Projects" :todo "PROJ")
          (:name "@flant" :tag "@flant")
          (:name "@anima" :tag "@anima")
          (:name "@errand" :tag "@errand")))
  (org-super-agenda-mode)
  ;; org-super-agenda-header-map is `(copy-keymap org-agenda-mode-map)' — a
  ;; raw, non-evil-aware copy — attached as a text-property `keymap' on every
  ;; group header line. Text-property keymaps outrank evil's own, so standing
  ;; on a header line silently drops out of evil entirely: `j'/`k' resolved to
  ;; org's raw `org-agenda-goto-date'/`org-agenda-capture', which then errored
  ;; ("Not allowed in 'todo'-type agenda buffer") — looked like navigation
  ;; just stopped dead at the first header. Rebind j/k there directly.
  (define-key org-super-agenda-header-map "j" #'org-agenda-next-line)
  (define-key org-super-agenda-header-map "k" #'org-agenda-previous-line)
  ;; Same issue, less severe (these don't error, just silently do something
  ;; else org-specific instead of the evil-bound action) — worth closing
  ;; anyway since "x" would otherwise exit the whole agenda and "u" would
  ;; bulk-unmark instead of undo.
  (define-key org-super-agenda-header-map "x" #'org-agenda-bulk-action)
  (define-key org-super-agenda-header-map "u" #'org-agenda-undo)
  (define-key org-super-agenda-header-map "m" #'org-agenda-bulk-toggle)
  (define-key org-super-agenda-header-map "p" #'org-agenda-previous-line)
  (define-key org-super-agenda-header-map "L" #'org-agenda-do-date-later)
  (define-key org-super-agenda-header-map "H" #'org-agenda-do-date-earlier)
  (define-key org-super-agenda-header-map "S" #'org-agenda-filter-remove-all))

;; Auto-reset checkboxes in a repeating TODO's subtree when it repeats, so
;; recurring checklists (review.org) come back unchecked instead of showing
;; last time's progress. Verified: without this, checkboxes stay checked.
(add-hook 'org-todo-repeat-hook #'org-reset-checkbox-state-subtree)

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

 (use-package org-journal
     :ensure t
     :defer t
     :init
     :custom
     (org-journal-prefix-key "C-c j ")
     (org-journal-dir "~/.local/src/datagrip/org/journal/")
     ;;(org-journal-date-format "%Y %m %B %d, %A")
     (org-journal-date-format "[%Y-%m-%d]:")
     (org-journal-file-type 'monthly)
     (org-journal-file-format "%Y-%m")
     ;; Entry style options — uncomment one pair, comment the others:
     ;;(org-journal-time-format "")     ;; bullet, no time: "- text"
     ;;(org-journal-time-prefix "- ")
     ;;(org-journal-time-format "%R ")  ;; heading + time: "** 14:30 text"
     ;;(org-journal-time-prefix "** ")
     (org-journal-time-format "")      ;; heading, no time (current): "** text"
     (org-journal-time-prefix "** ")
     ;; Speeds up calendar-heavy operations (SPC n j c, mark/search) — org-journal
     ;; caches which dates have entries instead of re-scanning files each time.
     (org-journal-enable-cache t)
     ;; Title every new monthly file, consistent with todo.org/notes.org/etc.
     (org-journal-file-header "#+TITLE: Journal %Y-%m\n")
     ;; Don't drag clock-log history forward onto carried-over TODOs.
     (org-journal-skip-carryover-drawers '("LOGBOOK"))
     ;; Prompt to delete a day's entry if carrying its items forward empties it,
     ;; instead of silently leaving an empty stub heading (default) or silently
     ;; deleting it without asking.
     (org-journal-carryover-delete-empty-journal 'ask)
     :config
     (defun org-journal-save-entry-and-exit ()
       "Save the buffer of the current day's entry and kill the window.
Similar to org-capture-like behavior."
       (interactive)
       (save-buffer)
       (kill-buffer-and-window))
     (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

     ;; org-journal only binds C-c j {f,b,j,s} inside `org-journal-mode-map',
     ;; i.e. once you're already in a journal buffer. That leaves no way to
     ;; enter the journal from anywhere else, so bind the entry points globally
     ;; too.
     (map! "C-c j j" #'org-journal-new-entry
           "C-c j s" #'org-journal-search)

     ;; Doom's default "j" org-capture template writes into a separate
     ;; journal.org via datetree, which would fork journal entries away from
     ;; org-journal's own monthly files. Route it through org-journal instead
     ;; (recipe from the org-journal README's org-capture integration section)
     ;; so `SPC X j' and `C-c j j' land in the same place.
     (defun +org-journal-capture-location ()
       (org-journal-new-entry t)
       (unless (eq org-journal-file-type 'daily)
         (org-narrow-to-subtree))
       (goto-char (point-max)))
     (after! org
       (setf (alist-get "j" org-capture-templates nil nil #'equal)
             '("Journal entry" plain (function +org-journal-capture-location)
               "** %^{Title}\n%i%?" :jump-to-captured t)))
     )

(map! "<f5>" #'deadgrep)

;; `SPC b d' (kill-current-buffer) only asks yes/no "kill anyway?" for a
;; modified buffer — no option to save first. Ask that explicitly instead.
(defun +smart-kill-buffer ()
  "Offer to save a modified file-visiting buffer before killing it."
  (interactive)
  (when (and (buffer-modified-p) (buffer-file-name))
    (when (y-or-n-p "Save before killing? ")
      (save-buffer)))
  ;; We've already decided; skip Emacs's own now-redundant "kill anyway?".
  (let ((kill-buffer-query-functions nil))
    (kill-current-buffer)))
(map! :leader "b d" #'+smart-kill-buffer
      :leader "b k" #'+smart-kill-buffer) ;; same command as "b d", just an alias key

;; Doom remaps `delete-frame' (bound to SPC q f) to
;; `doom/delete-frame-with-prompt', which asks "Close frame?" whenever more
;; than one frame is open, and calls `save-buffers-kill-emacs' (killing the
;; whole daemon, not just the frame) when it's the last one. Since Emacs runs
;; here as a daemon (emacsclient -c -a ''), plain `delete-frame' is the
;; correct behavior in both cases: no prompt, and closing the last client
;; frame just closes the frame instead of taking down the daemon.
(global-set-key [remap delete-frame] #'delete-frame)

;; The "When done with this frame, type SPC q f" echo-area message on every
;; new client frame (stock Emacs server.el, keybinding shown is whatever's
;; currently bound to `delete-frame'). Uncomment to silence it.
;;(setq server-client-instructions nil)

;; Force the keyboard layout back to English whenever leaving insert or
;; ex/command-line state (mirrors the InsertLeave/CmdlineLeave autocmds in
;; ~/.config/nvim/lua/config/autocmds.lua), reusing the same script.
;; `evil-normal-state-entry-hook' fires on the way back to Normal state from
;; any of insert, visual or ex — covering both nvim autocmds in one hook.
(defun +evil-switch-to-english-layout-h ()
  (start-process "hypr-switch-en" nil (expand-file-name "~/.local/bin/hypr-switch-en")))
(add-hook 'evil-normal-state-entry-hook #'+evil-switch-to-english-layout-h)

;; Hide line numbers while in zen mode (SPC t z / SPC t Z) and restore them
;; when it's turned back off.
(after! writeroom-mode
  (add-hook 'writeroom-mode-enable-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'writeroom-mode-disable-hook (lambda () (display-line-numbers-mode 1))))

;; Эта тема нужна, чтобы при вставки сниппета даты не выходило следующее предупреждение:
;; To hide this warning, add (yasnippet backquote-change) to `warning-suppress-types'.
(require 'warnings)
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))

;; Auto-discover every project (git repo etc.) directly under ~/.local/src,
;; instead of registering them one at a time. Runs automatically the first
;; time SPC p p or similar is used (`projectile-auto-discover' defaults to t).
(setq projectile-project-search-path '("~/.local/src/"))

;;; --- Omarchy integration (merged 2026-09-04) ---
;; ~/.config/emacs is now this Doom install itself (the omarchy-emacs AUR
;; package's own init.el/omarchy.el shim were moved aside to
;; ~/.config/emacs.omarchy-backup.20260904-230348). Loading the same shim
;; here gives Doom live theme + font sync with the system Omarchy theme,
;; exactly like the stock profile had. This overrides the doom-font/
;; doom-variable-pitch-font/doom-unicode-font set above — that's intentional,
;; font sync was requested too. `omarchy-restart-emacs` (invoked by the
;; theme-set/font-set hooks) reloads ~/.config/emacs/omarchy.el directly on
;; every theme/font change, so it doesn't need Doom to still be running this
;; block after startup — this call only handles the initial sync.
;;
;; omarchy-emacs may overwrite ~/.config/emacs/init.el and/or
;; ~/.config/emacs/omarchy.el on an AUR upgrade (`omarchy-emacs-setup`
;; re-run); watch for that and re-apply this merge if it happens.
(load (expand-file-name "omarchy.el" doom-emacs-dir) 'noerror)

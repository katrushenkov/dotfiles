;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(load! "private.el" doom-user-dir t)

;; Show the which-key popup almost immediately instead of waiting.
(setq which-key-idle-delay 0.0
      which-key-idle-secondary-delay 0.0)

(setq-default default-directory "~/.local/src/datagrip/")

;; The dashboard buffer (shown in every new `emacsclient -c' frame) is
;; created before this file loads, with `default-directory' inherited from
;; the daemon's own startup cwd ($HOME — the systemd unit sets no
;; WorkingDirectory) — `setq-default' above doesn't reach its already-set
;; buffer-local value. `+dashboard-pwd-policy' as a fixed string pins it
;; directly instead of relying on the "last visited file/project" fallback
;; chain (see `+dashboard--pwd').
(setq +dashboard-pwd-policy "~/.local/src/datagrip/")

;; Drop the Doom Emacs ASCII banner from the dashboard. `+dashboard-widget-banner'
;; inserts the ASCII art text first and then, in a graphical frame, overlays
;; `fancy-splash-image' on top of that same text region — so nil'ing the
;; ASCII-art function (rather than removing the widget from
;; `+dashboard-functions') takes the graphical logo down with it too, not
;; just the ASCII fallback. The other widgets (shortcuts, footer, loaded-in
;; time) are unaffected.
(setq +dashboard-ascii-banner-fn nil)

;; Drop the GitHub-icon line too — that's the whole of `+dashboard-widget-footer'
;; (just an octoface icon/link to github.com/doomemacs), so remove the widget
;; from `+dashboard-functions' entirely rather than blanking its content.
(setq +dashboard-functions (remove '+dashboard-widget-footer +dashboard-functions))

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
(setq org-directory "~/.local/src/datagrip/")
;;(setq org-directory "~/org/")

(use-package org-contacts
  :ensure nil
  :after org
  :custom (org-contacts-files '("~/.local/src/datagrip/contacts.org"))
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
                              "~/.local/src/datagrip/journal/"))

;; `SPC m A' (org-archive-subtree) files everything into one consolidated,
;; date-tree-organized archive instead of scattering a `<file>_archive'
;; sibling next to every source file. ".archive/" being a subdirectory
;; already keeps it out of org-agenda-files/org-refile-targets (non-recursive
;; scan) without any extra exclusion needed.
(setq org-archive-location (concat org-directory ".archive/archive.org::datetree/"))

;; "f" capture template: quick notes into their own top-level file
;; (flant.org), separate from the general notes.org. Lives at org-directory's
;; top level, so org-agenda-files' non-recursive scan (see above) picks it up
;; automatically. Every entry is tagged :flant: up front — baked into the
;; template text rather than via `%^g' (which would prompt every time) since
;; it should always apply here. Still just an ordinary org tag string once
;; inserted, so extra tags can be added on top: type more `:tag:'s right
;; next to it before finalizing, or `SPC m q' (`org-set-tags-command') for
;; the usual completing prompt — either sees :flant: as already set and adds
;; to it rather than replacing it.
;;
;; `alist-get'+`setf' (same pattern as the "j" journal override below)
;; instead of `add-to-list': "f" isn't a Doom-default key, so `add-to-list'
;; would still work the first time, but it matches by `equal' on the whole
;; entry — re-editing the template text later (as just happened) makes it no
;; longer `equal' to what's already in the list, so add-to-list prepends a
;; second "f" entry instead of replacing the first. `org-capture' still picks
;; the front one (correct, since add-to-list prepends), so it isn't silently
;; broken, but it leaves a stale duplicate sitting behind it — confusing to
;; debug later. `alist-get'+`setf' always replaces the "f" entry in place.
(after! org
  (setf (alist-get "f" org-capture-templates nil nil #'equal)
        '("Flant" entry
          (file+headline "flant.org" "Inbox")
          "* TODO %? :flant:\n%i" :prepend t)))

;; Doom's default "n"/"pn"/"on" (notes / project-local notes / centralized
;; project notes) templates prefix every entry with a `%u'/`%U' timestamp.
;; Strip that — just the heading text, no date/time — while leaving the
;; rest of each template (target file, `%i' body, `:prepend') as-is.
;; `%a' (link to wherever capture was invoked from) dropped too, same as in
;; every other template below — see the comment above the "t"/"pt"/"pc"/
;; "ot"/"oc" overrides for why.
(after! org
  (setf (alist-get "n" org-capture-templates nil nil #'equal)
        '("Personal notes" entry
          (file+headline +org-capture-notes-file "Inbox")
          "* %?\n%i" :prepend t))
  (setf (alist-get "pn" org-capture-templates nil nil #'equal)
        '("Project-local notes" entry
          (file+headline +org-capture-project-notes-file "Inbox")
          "* %?\n%i" :prepend t))
  (setf (alist-get "on" org-capture-templates nil nil #'equal)
        '("Project notes" entry
          (function +org-capture-central-project-notes-file)
          "* %?\n %i"
          :heading "Notes"
          :prepend t)))

;; Drop `%a' — a link back to wherever capture was invoked from — from every
;; remaining Doom-default template ("t" personal todo, and the project
;; variants "pt"/"pc"/"ot"/"oc"). Whether that link actually turns into
;; anything visible depends on the buffer capture was invoked from (see
;; `org-store-link' in org-capture.el: file buffers and org-mode headings
;; get a real link, buffers with no store-link handler like `*scratch*' or
;; a shell get silently nothing) — inconsistent enough to just never insert
;; it. "n"/"pn"/"on"/"f"/"j" already don't include `%a' in their own
;; overrides above/below.
(after! org
  (setf (alist-get "t" org-capture-templates nil nil #'equal)
        '("Personal todo" entry
          (file+headline +org-capture-todo-file "Inbox")
          "* [ ] %?\n%i" :prepend t))
  (setf (alist-get "pt" org-capture-templates nil nil #'equal)
        '("Project-local todo" entry
          (file+headline +org-capture-project-todo-file "Inbox")
          "* TODO %?\n%i" :prepend t))
  (setf (alist-get "pc" org-capture-templates nil nil #'equal)
        '("Project-local changelog" entry
          (file+headline +org-capture-project-changelog-file "Unreleased")
          "* %U %?\n%i" :prepend t))
  (setf (alist-get "ot" org-capture-templates nil nil #'equal)
        '("Project todo" entry
          (function +org-capture-central-project-todo-file)
          "* TODO %?\n %i"
          :heading "Tasks"
          :prepend nil))
  (setf (alist-get "oc" org-capture-templates nil nil #'equal)
        '("Project changelog" entry
          (function +org-capture-central-project-changelog-file)
          "* %U %?\n %i"
          :heading "Changelog"
          :prepend t)))

;; Let `:w'/`:wq'/`:x' finalize a capture (like `C-c C-c'), not just save (or
;; save-and-close) the buffer — `save-buffer' on a capture buffer doesn't file
;; the entry into its target or clean up the capture state. Buffer-local:
;; makes `evil-ex-commands' local first (`evil--add-to-alist' then mutates
;; that local copy via `setq'), so this only shadows these commands inside
;; capture buffers, not globally.
(add-hook 'org-capture-mode-hook
          (defun +org-capture-evil-w-finalizes-h ()
            (setq-local evil-ex-commands (copy-alist evil-ex-commands))
            (dolist (cmd '("w[rite]" "wq" "x[it]"))
              (evil-ex-define-cmd cmd #'org-capture-finalize))))

;; Leftover which-key popup after invoking capture via a leader-key sequence
;; (e.g. `SPC X j'): Doom's ui/popup module advises `org-capture-place-template'
;; to temporarily redefine `delete-window'/`delete-other-windows' to no-ops
;; for that call's duration (`+popup--suppress-delete-other-windows-a', so org
;; doesn't monopolize the frame). which-key's side-window popup closes via
;; `quit-windows-on' -> `delete-window' (`which-key--hide-buffer-side-window'
;; in which-key.el) — if that close happens to land inside the same window,
;; it's swallowed and the popup is left on screen. Force it closed once the
;; capture buffer exists, regardless of whether the earlier close succeeded.
(add-hook 'org-capture-mode-hook #'which-key--hide-popup-ignore-command)

(map! :leader
      (:prefix "n"
       :desc "Open org index" "i" (cmd! (find-file (expand-file-name "index.org" org-directory)))
       (:prefix ("j" . "journal")
        :desc "New/today's entry" "j" #'org-journal-new-entry
        :desc "New entry on date" "d" #'org-journal-new-date-entry
        :desc "Search"            "s" #'org-journal-search
        :desc "Open calendar"     "c" #'calendar)))

;; `SPC Q' takes over the "quit/session" menu that `SPC q' used to open (see
;; Doom's default `+evil-bindings.el' — restart/quit/save-session/etc, still
;; reachable the same way, just one key over). Freed from being a prefix,
;; `SPC q' becomes a direct leaf binding for "Delete frame" (was `SPC q f').
;; `lookup-key' grabs the existing quit/session keymap before the second
;; `map!' entry overwrites what "q" points to — order matters here.
(map! :leader
      :desc "Quit/session" "Q" (lookup-key doom-leader-map (kbd "q"))
      :desc "Delete frame" "q" #'delete-frame)

;; `f' in normal state jumps via avy (timer-based char search, labels on
;; every match on screen) instead of evil's native "find char on this line".
;; Was already available unprefixed as `gs /' (see evil-easymotion config);
;; this just makes it the default `f'.
;;
;; Caveat: this replaces `f' as an evil *motion*, not just a standalone
;; command — `evil-avy-goto-char-timer' jumps point directly and doesn't
;; return a motion range, so operator-pending uses of `f' (`df', `cf', `yf',
;; …) stop working. If that's needed, rebind to an `evilem-create'-wrapped
;; version of `evil-find-char' instead (see the `gs a'/`gs A' pattern above)
;; — that stays operator-compatible since it re-runs the real motion after
;; the avy jump picks a target character.
(map! :n "f" #'evil-avy-goto-char-timer)

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
    (org-agenda-to-appt t)
    ;; `org-agenda-to-appt' opens the `diary' file as a normal buffer and
    ;; never closes it. Since this runs on every startup/every 10min, that
    ;; buffer ends up the most recently touched one in the buffer list —
    ;; which `quit-window' (dashboard's "q", inherited from `special-mode')
    ;; falls back to on a fresh frame with no window history. Hide it like
    ;; an internal buffer instead (nobody edits `diary' directly, see its
    ;; note in org-notes.md) — renaming doesn't affect its file
    ;; association, just excludes it from `other-buffer'/buffer-switching.
    (when-let* ((buf (get-file-buffer diary-file)))
      (with-current-buffer buf
        (unless (string-prefix-p " " (buffer-name))
          (rename-buffer (concat " " (buffer-name)) t)))))
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

;; Extends org-modern's styling to source-block indentation guides. Purely
;; visual, complements the org-modern already enabled via the org +pretty
;; flag in init.el. org-startup-indented is t (Doom default), so
;; org-indent-mode always runs in org buffers and this hook always fires.
(use-package! org-modern-indent
  :hook (org-indent-mode . org-modern-indent-mode))

;; Reveal emphasis markers/links/sub-superscripts when the cursor is on
;; them, hide them otherwise — complements org-modern (org +pretty), which
;; hides that same syntax by default and would otherwise make it invisible
;; to edit. org-appear-delay 0: evil motions jump discretely between
;; objects rather than moving the cursor continuously like typing, so the
;; default 0.7s debounce (meant to avoid flicker while typing/scrolling
;; character-by-character) only adds latency here — reveal immediately.
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-delay 0))

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
     :demand t
     :init
     :custom
     (org-journal-prefix-key "C-c j ")
     (org-journal-dir "~/.local/src/datagrip/journal/")
     ;; Default is `find-file-other-window', which always splits the current
     ;; window to open the journal entry — if that window (or another one)
     ;; already shows the journal buffer, you end up looking at it twice.
     ;; Plain `find-file' reuses an existing window on that buffer instead of
     ;; forcing a split.
     (org-journal-find-file-fn #'find-file)
     ;;(org-journal-date-format "%Y %m %B %d, %A")
     (org-journal-date-format "[%Y-%m-%d]:")
     (org-journal-file-type 'monthly)
     (org-journal-file-format "%Y-%m")
     ;; Entry style options — uncomment one pair, comment the others:
     ;;(org-journal-time-format "")     ;; bullet, no time: "- text"
     ;;(org-journal-time-prefix "- ")
     ;;(org-journal-time-format "%R ")  ;; heading + time: "** 14:30 text"
     ;;(org-journal-time-prefix "** ")
     ;;(org-journal-time-format "")      ;; heading, no time: "** text"
     ;;(org-journal-time-prefix "** ")
     (org-journal-time-format "[%Y-%m-%d %a] ")  ;; heading + standard inactive timestamp (current): "** [2026-09-09 Wed] text"
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
     ;; Non-nil only in buffers where a new entry was actually inserted via
     ;; `org-journal-new-entry' (`SPC n j j' / `C-c j j') — set by the hook
     ;; below. Stays nil when the journal file is opened directly for
     ;; ordinary editing (e.g. `find-file' on a monthly file), so that saving
     ;; there behaves like a normal buffer instead of closing the window.
     (defvar-local +org-journal-close-on-save nil)
     (add-hook 'org-journal-after-entry-create-hook
               (defun +org-journal-mark-close-on-save-h ()
                 (setq +org-journal-close-on-save t)))

     (defun org-journal-save-entry-and-exit ()
       "Save the buffer. If it holds a freshly created entry (see
`+org-journal-close-on-save'), also kill the window — capture-like.
Otherwise just save, leaving the window open for normal editing."
       (interactive)
       (save-buffer)
       (when +org-journal-close-on-save
         (kill-buffer-and-window)))
     (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

     (defun +org-journal-save-and-quit ()
       "Save the buffer and kill the window, unconditionally.
Standard `:wq'/`:x' semantics — unlike plain `:w' (`org-journal-save-entry-and-exit'),
these always quit the window, whether or not the buffer holds a freshly
created entry."
       (interactive)
       (save-buffer)
       (kill-buffer-and-window))

     ;; Same reasoning as the org-capture `:w'/`:wq'/`:x' override above:
     ;; without this, evil's `:w' just calls plain `save-buffer' here, so the
     ;; journal window/buffer stays open after "finishing" an entry — only
     ;; `C-x C-s' (bound just above) closed it. Buffer-local, via a local copy
     ;; of `evil-ex-commands', so this doesn't touch `:w' anywhere else.
     ;; `:w' defers to `org-journal-save-entry-and-exit' (closes only for a
     ;; freshly created entry, see `+org-journal-close-on-save' above); `:wq'
     ;; and `:x' always close, matching their standard save-and-quit meaning.
     (add-hook 'org-journal-mode-hook
               (defun +org-journal-evil-w-saves-and-exits-h ()
                 (setq-local evil-ex-commands (copy-alist evil-ex-commands))
                 (evil-ex-define-cmd "w[rite]" #'org-journal-save-entry-and-exit)
                 (dolist (cmd '("wq" "x[it]"))
                   (evil-ex-define-cmd cmd #'+org-journal-save-and-quit))))

     ;; org-journal only binds C-c j {f,b,j,s} inside `org-journal-mode-map',
     ;; i.e. once you're already in a journal buffer. That leaves no way to
     ;; enter the journal from anywhere else, so bind the entry points globally
     ;; too.
     (map! "C-c j j" #'org-journal-new-entry
           "C-c j s" #'org-journal-search)
     )

;; Doom's default "j" org-capture template writes into a separate journal.org
;; via datetree, which would fork journal entries away from org-journal's own
;; monthly files. Route it through org-journal instead (recipe from the
;; org-journal README's org-capture integration section) so `SPC X j' and
;; `C-c j j' land in the same place.
;;
;; Deliberately OUTSIDE `use-package org-journal's `:config': org-journal is
;; `:demand t' now (loads unconditionally at startup, see above) specifically
;; so this override is always in place before any capture runs — but it used
;; to be `:defer t', and this override used to live inside `:config' too,
;; which only runs once some org-journal command is actually called. Verified
;; that gap was real: some entries landed in journal.org because capture ran
;; before org-journal's :config had a chance to install the override. Keeping
;; the override out here as well costs nothing and doesn't reintroduce that
;; failure mode if `:demand' ever reverts to `:defer' again.
(defun +org-journal-capture-location ()
  ;; `org-capture-place-template' always pops up its OWN window afterward,
  ;; on an indirect clone of whatever buffer we leave current here (see
  ;; `org-capture-place-template' in org-capture.el: `pop-to-buffer' on an
  ;; `org-capture-get-indirect-buffer' result, unconditionally, regardless of
  ;; capture target type). `org-journal-new-entry' — via `org-journal-find-file-fn'
  ;; — normally ALSO switches to/displays the monthly file itself. Do both and
  ;; you get two windows on the same content: the plain buffer (from here) and
  ;; the indirect CAPTURE- buffer (from org-capture) — a real duplicate,
  ;; since window-reuse logic keys off buffer identity and an indirect buffer
  ;; doesn't count as "already showing" its base buffer. Locally rebinding to
  ;; a non-displaying opener avoids that: just set the buffer current, let
  ;; org-capture's own pop-to-buffer be the only thing that shows a window.
  ;; (Direct `org-journal-new-entry' calls — `SPC n j j', `C-c j j' — don't go
  ;; through org-capture at all, so they still use the global
  ;; `org-journal-find-file-fn' (`find-file') set above and display normally.)
  ;; PREFIX (t) also tells `org-journal-new-entry' to skip its own auto
  ;; timestamp heading, leaving just the day's subtree — the "j" capture
  ;; template below supplies the `**' heading (and its own timestamp) itself.
  (let ((org-journal-find-file-fn (lambda (file) (set-buffer (find-file-noselect file)))))
    (org-journal-new-entry t))
  (unless (eq org-journal-file-type 'daily)
    (org-narrow-to-subtree))
  (goto-char (point-max)))
;; No `%^{Title}' prompt: type the title straight into the heading via `%?'
;; instead. `%^{...}' escapes are filled in `org-capture-fill-template' by
;; inserting the raw, not-yet-substituted template text into a scratch buffer
;; literally named "*Capture*" and prompting there (see `org-capture.el') —
;; while that prompt is up, that scratch buffer (still showing unexpanded
;; escapes, `%?' included) is genuinely visible in a window. Harmless — it's
;; wrapped in `save-window-excursion' and never reaches the saved entry — but
;; skipping the separate prompt avoids the extra window/flash entirely.
(after! org
  (setf (alist-get "j" org-capture-templates nil nil #'equal)
        '("Journal entry" plain (function +org-journal-capture-location)
          "** %<[%Y-%m-%d %a]> %?\n%i")))

;; deft (:ui deft module, enabled in init.el): incremental fuzzy search over
;; note filenames+content, bound to "SPC n d" by Doom's own default module
;; config — nothing to bind here. deft-recursive t so it also reaches
;; journal/ and archive/, not just org-directory's top level.
(setq deft-directory org-directory
      deft-recursive t)

(map! "<f5>" #'deadgrep)

;; `;x' toggles the scratch buffer. Note this shadows evil's `;' (repeat
;; last f/F/t/T search) — accepted tradeoff, that binding isn't used here.
(map! :n ";x" #'doom/toggle-scratch-buffer)

;; `;e' opens the current file in the system default editor, in its own
;; terminal window (running a TUI editor inside an Emacs term.el buffer broke
;; rendering — nested TUI-in-TUI fights over the terminal).
;;
;; NOT going through `omarchy-launch-editor'/`omarchy-launch-tui': both hop
;; through `uwsm-app', whose daemon (`uwsm aux app-daemon') proved flaky when
;; tested from a shell here — "Timed out trying to write to
;; /run/user/1000/uwsm-app-daemon-in!" and, once the daemon was up, a pty
;; write failure — silently, since Emacs's `start-process' had nowhere to
;; show that stderr. `xdg-terminal-exec' alone (no uwsm dependency) reliably
;; opened a new terminal window in the same testing.
(defun +open-file-in-editor ()
  "Open the current buffer's file in the default editor, in its own window."
  (interactive)
  (let* ((file (or (buffer-file-name) (user-error "Buffer is not visiting a file")))
         (editor-file (expand-file-name "~/.local/state/omarchy/defaults/editor"))
         (editor (if (file-readable-p editor-file)
                     (string-trim (with-temp-buffer
                                    (insert-file-contents editor-file)
                                    (buffer-string)))
                   "nvim")))
    (start-process "term-editor" nil "xdg-terminal-exec" "-e" editor file)))
(map! :n ";e" #'+open-file-in-editor)

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

;; Omarchy's SUPER+V ("Universal paste") sends Ctrl+Shift+V specifically to
;; Emacs windows (see the `active_window_is_emacs' branch in
;; ~/.config/hypr/bindings.lua), because neither of the obvious stand-ins
;; works here: plain C-v is scroll-down, and evil rebinds C-y to
;; `evil-copy-from-above' in insert state. C-S-v is unbound in every evil
;; state (checked normal/insert/visual/motion + minibuffer), so bind it
;; globally to plain `yank', which already pulls from the system clipboard
;; over the kill-ring via `select-enable-clipboard' (t by default).
(map! "C-S-v" #'yank)

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

;; kubel: kubectl-in-Emacs. Edit a resource's YAML buffer and hit `C-c C-c'
;; to `kubectl apply' it; `?' in the overview lists all other bindings.
(use-package! kubel
  :commands (kubel)
  :config
  (setq kubel-use-namespace-list t)
  (require 'kubel-evil))

(map! :leader
      (:prefix "o"
       :desc "Kubel" "k" #'kubel
       :desc "Org capture" "c" #'org-capture)
      (:prefix "s"
       :desc "Grep (cwd)"       "g" #'+default/search-cwd
       :desc "Grep (project)"   "G" #'+default/search-project))

;;; --- Omarchy integration (merged 2026-09-04) ---
;; ~/.config/emacs is now this Doom install itself (the omarchy-emacs AUR
;; package's own init.el/omarchy.el shim were moved aside to
;; ~/.config/emacs.omarchy-backup.20260904-230348). $DOOMDIR/+omarchy.el
;; loads that shim itself (for its helper functions/vars), then advice-overrides
;; `omarchy-apply-theme'/`omarchy-apply-font' with Doom-aware versions (custom
;; `omarchy-doom' theme, pgtk-corrected font sizing, and untangling the stock
;; `delete-trailing-whitespace' hook from Doom's own whitespace handling) —
;; loading the bare shim directly, as this used to, skips all of that and
;; silently falls back to the stock plain `omarchy' theme instead. The advice
;; is installed on the symbol, so it survives `omarchy-restart-emacs' (invoked
;; by the theme-set/font-set hooks) reloading ~/.config/emacs/omarchy.el later
;; — this call only needs to run once, at startup.
;;
;; omarchy-emacs may overwrite ~/.config/emacs/init.el and/or
;; ~/.config/emacs/omarchy.el on an AUR upgrade (`omarchy-emacs-setup`
;; re-run); watch for that and re-apply this merge if it happens.
(load! "+omarchy")

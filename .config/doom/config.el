;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Rationale for the non-obvious bits below lives in
;; ~/.local/src/datagrip/sc/doom/CLAUDE.md.

(load! "private.el" "~/.local/src/datagrip/private/configs/" t)

(setq which-key-idle-delay 0.0
      which-key-idle-secondary-delay 0.0)

(setq-default default-directory "~/.local/src/datagrip/")
;; The dashboard buffer exists before this file loads, so `setq-default'
;; above doesn't reach it; pin its cwd directly.
(setq +dashboard-pwd-policy "~/.local/src/datagrip/")

;; No banner (nil fn also drops the graphical logo) and no GitHub footer.
(setq +dashboard-ascii-banner-fn nil)
(setq +dashboard-functions (remove '+dashboard-widget-footer +dashboard-functions))

(setq display-line-numbers-type t)

;; Frame padding matching Omarchy's window gaps.
(add-to-list 'default-frame-alist '(internal-border-width . 8))

(setq-default delete-by-moving-to-trash t)  ; dired deletes go to the freedesktop trash
(setq scroll-margin 3
      evil-want-fine-undo t)

(setq org-directory "~/.local/src/datagrip/")

(use-package! org-contacts
  :after org
  :custom (org-contacts-files '("~/.local/src/datagrip/contacts.org"))
  :config
  ;; "@Name" completion checks `major-mode' literally; journal isn't listed.
  (add-to-list 'org-contacts-completion-enabled-mode-list 'org-journal-mode))

;; Directories are scanned non-recursively (top-level *.org only).
(setq org-agenda-files (list org-directory
                             "~/.local/src/datagrip/journal/"))

;; One date-tree archive; .archive/ is outside the non-recursive agenda scan.
(setq org-archive-location (concat org-directory ".archive/archive.org::datetree/"))

;;; Capture templates
;; `setf'+`alist-get' replaces entries in place (`add-to-list' would leave
;; stale duplicates after editing). `%a' and `%u'/`%U' prefixes are dropped
;; from Doom's defaults on purpose.

;; Real name is machine-local: private.el may `defvar' it first.
(defvar my/work-org-file "work.org"
  "Top-level org file for the \"w\" capture template.")

(after! org
  (dolist (tpl
           `(("w" "Work" entry
              (file+headline ,my/work-org-file "Inbox")
              "* TODO %? :work:\n%i" :prepend t)
             ("b" "Book" entry
              (file "books.org")
              "* %^{Название}\n%^{AUTHOR}p%^{YEAR}p"
              :immediate-finish t)
             ("n" "Personal notes" entry
              (file+headline +org-capture-notes-file "Inbox")
              "* %?\n%i" :prepend t)
             ("pn" "Project-local notes" entry
              (file+headline +org-capture-project-notes-file "Inbox")
              "* %?\n%i" :prepend t)
             ("on" "Project notes" entry
              (function +org-capture-central-project-notes-file)
              "* %?\n %i" :heading "Notes" :prepend t)
             ("t" "Personal todo" entry
              (file+headline +org-capture-todo-file "Inbox")
              "* [ ] %?\n%i" :prepend t)
             ("pt" "Project-local todo" entry
              (file+headline +org-capture-project-todo-file "Inbox")
              "* TODO %?\n%i" :prepend t)
             ("pc" "Project-local changelog" entry
              (file+headline +org-capture-project-changelog-file "Unreleased")
              "* %U %?\n%i" :prepend t)
             ("ot" "Project todo" entry
              (function +org-capture-central-project-todo-file)
              "* TODO %?\n %i" :heading "Tasks" :prepend nil)
             ("oc" "Project changelog" entry
              (function +org-capture-central-project-changelog-file)
              "* %U %?\n %i" :heading "Changelog" :prepend t)
             ;; Routed through org-journal so captures land in the monthly files.
             ("j" "Journal entry" plain (function +org-journal-capture-location)
              "** %<[%Y-%m-%d %a]> %?\n%i")))
    (setf (alist-get (car tpl) org-capture-templates nil nil #'equal)
          (cdr tpl))))

;; `:w'/`:wq'/`:x' finalize a capture instead of just saving the buffer.
(add-hook 'org-capture-mode-hook
          (defun +org-capture-evil-w-finalizes-h ()
            (setq-local evil-ex-commands (copy-alist evil-ex-commands))
            (dolist (cmd '("w[rite]" "wq" "x[it]"))
              (evil-ex-define-cmd cmd #'org-capture-finalize))))

;; Popup module can swallow which-key's close during capture; force it.
(add-hook 'org-capture-mode-hook #'which-key--hide-popup-ignore-command)

;;; Org look & behaviour

;; Plain-text timestamps: org-modern's 0.8-height badge misaligns tables.
(after! org-modern
  (setq org-modern-timestamp nil))

;; personal/work are mutually exclusive.
(setq org-tag-alist
      '((:startgroup)
        ("personal" . ?p)
        ("work" . ?w)
        (:endgroup)
        ("call" . ?c)
        ("read" . ?r)
        ("crypt" . ?x)))

;; :crypt: encrypts the body only — the heading title stays plaintext.
(after! org-crypt
  (setq org-crypt-key user-mail-address))

;; Birthdays come from `%%(org-contacts-anniversaries)' in contacts.org;
;; deliberately no diary file (appt would leave contacts.org open).

(setq org-agenda-custom-commands
      '(("d" "Day: agenda + active tasks"
         ((agenda "" ((org-agenda-span 1)))
          (todo "TODO|PROJ|STRT"
                ((org-agenda-overriding-header "Active tasks")))))
        ("h" "personal tasks" tags-todo "personal")
        ("w" "work tasks" tags-todo "work")
        ("r" "Review: week ahead + stuck items"
         ((agenda "" ((org-agenda-span 7)))
          (todo "WAIT" ((org-agenda-overriding-header "Waiting on")))
          (todo "PROJ" ((org-agenda-overriding-header "Projects")))))))

;; Desktop notification at the exact time of any timed SCHEDULED/DEADLINE.
(defvar +org-appt-timer nil)
(use-package! appt
  :after org
  :config
  (setq appt-message-warning-time 0
        appt-display-interval 1
        appt-display-mode-line nil
        appt-audible nil)
  (defun +org-appt-notify (_min-to-app _new-time appt-msg)
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
  ;; Cancel the previous timer so config reloads don't stack them.
  (when (timerp +org-appt-timer) (cancel-timer +org-appt-timer))
  (setq +org-appt-timer (run-at-time nil (* 10 60) #'+org-refresh-appt))
  (add-hook 'org-capture-after-finalize-hook #'+org-refresh-appt))

(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups
        '((:name "Overdue" :deadline past :scheduled past)
          (:name "Today" :time-grid t :deadline today :scheduled today)
          (:name "High priority" :priority "A")
          (:name "Waiting" :todo "WAIT")
          (:name "Projects" :todo "PROJ")
          (:name "work" :tag "work")
          (:name "personal" :tag "personal")))
  (org-super-agenda-mode)
  ;; Header lines carry a non-evil keymap copy that outranks evil; restore
  ;; the evil-collection keys there.
  (define-key org-super-agenda-header-map "j" #'org-agenda-next-line)
  (define-key org-super-agenda-header-map "k" #'org-agenda-previous-line)
  (define-key org-super-agenda-header-map "x" #'org-agenda-bulk-action)
  (define-key org-super-agenda-header-map "u" #'org-agenda-undo)
  (define-key org-super-agenda-header-map "m" #'org-agenda-bulk-toggle)
  (define-key org-super-agenda-header-map "p" #'org-agenda-previous-line)
  (define-key org-super-agenda-header-map "L" #'org-agenda-do-date-later)
  (define-key org-super-agenda-header-map "H" #'org-agenda-do-date-earlier)
  (define-key org-super-agenda-header-map "S" #'org-agenda-filter-remove-all))

(use-package! org-modern-indent
  :hook (org-indent-mode . org-modern-indent-mode))

;; org-appear itself is enabled by org +pretty; just tune it.
(after! org-appear
  (setq org-appear-autoemphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-delay 0))

;; Repeating TODOs come back with their checkboxes unchecked (review.org).
(add-hook 'org-todo-repeat-hook #'org-reset-checkbox-state-subtree)

;; org-lint flags :AUTHOR: etc. in drawers as "misspelled export option";
;; they're plain metadata here.
(after! org-lint
  (setq org-lint--checkers
        (seq-remove (lambda (c) (eq (org-lint-checker-name c) 'misspelled-export-option))
                    org-lint--checkers)))

;;; Journal

;; :demand so the calendar has entry marks and org-journal's keys from the start.
(use-package! org-journal
  :demand t
  :custom
  (org-journal-prefix-key "C-c j ")
  (org-journal-dir "~/.local/src/datagrip/journal/")
  (org-journal-find-file-fn #'find-file)  ; reuse a window, don't split
  (org-journal-date-format "[%Y-%m-%d]:")
  (org-journal-file-type 'monthly)
  (org-journal-file-format "%Y-%m")
  (org-journal-time-format "[%Y-%m-%d %a] ")  ; "** [2026-09-09 Wed] text"
  (org-journal-time-prefix "** ")
  (org-journal-enable-cache t)
  (org-journal-file-header "#+TITLE: Journal %Y-%m\n")
  (org-journal-skip-carryover-drawers '("LOGBOOK"))
  (org-journal-carryover-delete-empty-journal 'ask)
  :config
  ;; Set only in buffers where `org-journal-new-entry' just inserted an
  ;; entry; plain visits of a journal file save like normal buffers.
  (defvar-local +org-journal-close-on-save nil)
  (add-hook 'org-journal-after-entry-create-hook
            (defun +org-journal-mark-close-on-save-h ()
              (setq +org-journal-close-on-save t)))
  (add-hook 'org-journal-after-entry-create-hook
            (defun +org-journal-enter-insert-state-h ()
              (when (bound-and-true-p evil-mode)
                (evil-insert-state))))

  (defun org-journal-save-entry-and-exit ()
    "Save; if the buffer holds a fresh entry, also kill the window."
    (interactive)
    (save-buffer)
    (when +org-journal-close-on-save
      (kill-buffer-and-window)))
  (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

  (defun +org-journal-save-and-quit ()
    "Save the buffer and kill the window, unconditionally."
    (interactive)
    (save-buffer)
    (kill-buffer-and-window))

  ;; Buffer-local `:w' = save (+close if fresh entry); `:wq'/`:x' = always close.
  (add-hook 'org-journal-mode-hook
            (defun +org-journal-evil-w-saves-and-exits-h ()
              (setq-local evil-ex-commands (copy-alist evil-ex-commands))
              (evil-ex-define-cmd "w[rite]" #'org-journal-save-entry-and-exit)
              (dolist (cmd '("wq" "x[it]"))
                (evil-ex-define-cmd cmd #'+org-journal-save-and-quit))))

  ;; org-journal binds these only inside journal buffers.
  (map! "C-c j j" #'org-journal-new-entry
        "C-c j s" #'org-journal-search))

;; Target of the "j" capture template. Opens the file without displaying it
;; (org-capture pops its own indirect buffer) and passes PREFIX so
;; org-journal skips its own heading — the template supplies it.
(defun +org-journal-capture-location ()
  (let ((org-journal-find-file-fn (lambda (file) (set-buffer (find-file-noselect file)))))
    (org-journal-new-entry t))
  (unless (eq org-journal-file-type 'daily)
    (org-narrow-to-subtree))
  (goto-char (point-max)))

;;; Books (books.org): show :AUTHOR: after each heading

(defun my/org-author-refresh ()
  "Show :AUTHOR: property after org headings (display-only overlay)."
  (interactive)
  (remove-overlays (point-min) (point-max) 'my-org-author t)
  (org-with-wide-buffer
   (goto-char (point-min))
   (while (re-search-forward org-heading-regexp nil t)
     (when-let ((author (org-entry-get (point) "AUTHOR")))
       (let ((ov (make-overlay (1- (line-end-position)) (line-end-position))))
         (overlay-put ov 'my-org-author t)
         (overlay-put ov 'after-string
                      (propertize (concat "  — " author) 'face 'shadow)))))))

(define-minor-mode my/org-author-mode
  "Show author after book name."
  :lighter " Auth"
  (if my/org-author-mode
      (progn (my/org-author-refresh)
             (add-hook 'after-save-hook #'my/org-author-refresh nil t))
    (remove-overlays (point-min) (point-max) 'my-org-author t)
    (remove-hook 'after-save-hook #'my/org-author-refresh t)))

(add-hook 'org-mode-hook
          (lambda ()
            (when (and buffer-file-name
                       (string= (file-name-nondirectory buffer-file-name) "books.org"))
              (my/org-author-mode 1))))

;;; Misc

;; Full-text fuzzy search over notes (SPC n d), including subdirectories.
(setq deft-directory org-directory
      deft-recursive t)

(setq projectile-project-search-path '("~/.local/src/"))

;; Silences the warning on inserting the date snippet.
(require 'warnings)
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))

(after! writeroom-mode
  (add-hook 'writeroom-mode-enable-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'writeroom-mode-disable-hook (lambda () (display-line-numbers-mode 1))))

;; Scratch has no file: make `:w'/`:wq'/`:x' persist it and close the window.
(defun +scratch-save-and-close ()
  "Persist the current scratch buffer and close its window."
  (interactive)
  (doom-persist-scratch-buffer-h)
  (quit-window))

(defun +scratch-evil-w-saves-and-closes-h ()
  (when (memq (current-buffer) (bound-and-true-p doom-scratch-buffers))
    (setq-local evil-ex-commands (copy-alist evil-ex-commands))
    (dolist (cmd '("w[rite]" "wq" "x[it]"))
      (evil-ex-define-cmd cmd #'+scratch-save-and-close))))
(add-hook 'doom-scratch-buffer-created-hook #'+scratch-evil-w-saves-and-closes-h)
;; A major-mode change wipes buffer-locals; re-apply.
(add-hook 'after-change-major-mode-hook #'+scratch-evil-w-saves-and-closes-h)

;; Opens in a new terminal via plain `xdg-terminal-exec' (not the uwsm-based
;; omarchy-launch-* wrappers, which proved flaky).
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

(defun +smart-kill-buffer ()
  "Offer to save a modified file-visiting buffer before killing it."
  (interactive)
  (when (and (buffer-modified-p) (buffer-file-name))
    (if (y-or-n-p "Save before killing? ")
        (save-buffer)
      ;; Skip `kill-buffer''s own C-level "kill anyway?" prompt.
      (set-buffer-modified-p nil)))
  (let ((kill-buffer-query-functions nil))
    (kill-current-buffer)))

;; Back to the English layout on returning to normal state (as in nvim).
;; `evil-previous-state' is nil for freshly created buffers, which also run
;; this hook; only react in the buffer actually on screen.
(defun +evil-switch-to-english-layout-h ()
  (when (and evil-previous-state
             (eq (current-buffer) (window-buffer (selected-window))))
    (start-process "hypr-switch-en" nil (expand-file-name "~/.local/bin/hypr-switch-en"))))
(add-hook 'evil-normal-state-entry-hook #'+evil-switch-to-english-layout-h)

(use-package! kubel
  :commands (kubel)
  :config
  (setq kubel-use-namespace-list t)
  (require 'kubel-evil))

;; Doom limits the first snipe to the current line; search the whole screen.
(after! evil-snipe
  (setq evil-snipe-scope 'visible
        evil-snipe-repeat-scope 'visible
        evil-snipe-spillover-scope 'visible))

;; Snappier label popup for `f' (avy-goto-char-timer); default is 0.5s.
(after! avy
  (setq avy-timeout-seconds 0.3))

;;; Keybindings

;; Daemon: closing the last frame must not kill Emacs, and no prompt.
(global-set-key [remap delete-frame] #'delete-frame)

(map! "<f5>"    #'deadgrep
      "C-S-v"   #'yank                       ; Omarchy SUPER+V sends this to Emacs
      :n "f"    #'evil-avy-goto-char-timer   ; NB: breaks df/cf/yf
      :n ";x"   #'doom/toggle-scratch-buffer ; shadows evil's `;'
      :n ";e"   #'+open-file-in-editor)

;; Order matters: grab the old `SPC q' keymap before rebinding "q".
(map! :leader
      :desc "Quit/session" "Q" (lookup-key doom-leader-map (kbd "q"))
      :desc "Delete frame" "q" #'delete-frame)

(map! :leader
      "b d" #'+smart-kill-buffer
      "b k" #'+smart-kill-buffer
      (:prefix "n"
       :desc "Find contact"   "b" #'org-contacts
       :desc "Open org index" "i" (cmd! (find-file (expand-file-name "index.org" org-directory)))
       (:prefix ("j" . "journal")
        :desc "New/today's entry" "j" #'org-journal-new-entry
        :desc "New entry on date" "d" #'org-journal-new-date-entry
        :desc "Search"            "s" #'org-journal-search
        :desc "Open calendar"     "c" #'calendar))
      (:prefix "o"
       :desc "Kubel"       "k" #'kubel
       :desc "Org capture" "c" #'org-capture)
      (:prefix "s"
       :desc "Grep (cwd)"     "g" #'+default/search-cwd
       :desc "Grep (project)" "G" #'+default/search-project)
      (:prefix "t"
       :desc "Re-sync Omarchy theme" "o" #'+omarchy-apply-theme))

(after! org
  (map! :map org-mode-map
        :localleader
        (:prefix ("x" . "crypt")
         :desc "Encrypt entry"                 "e" #'org-encrypt-entry
         :desc "Decrypt entry"                 "d" #'org-decrypt-entry
         :desc "Encrypt all entries in buffer" "E" #'org-encrypt-entries
         :desc "Decrypt all entries in buffer" "D" #'org-decrypt-entries)))

;; evil-collection drops vanilla's `v a'/`v A'. Only `v A' shows entries
;; archived with `SPC m A' (they move to the archive file).
(after! org-agenda
  (map! :map org-agenda-mode-map
        :n "v a" #'org-agenda-archives-mode
        :n "v A" (cmd! (org-agenda-archives-mode 'files))))

;; Discoverable mirror of org-journal's raw calendar keys.
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

;;; Omarchy theme/font sync (sets `doom-theme' itself) — see +omarchy.el.
(load! "+omarchy")

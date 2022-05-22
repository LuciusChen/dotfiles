;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Lucius Chen"
      user-mail-address "chenyh572@gmail.com")
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
;; https://github.com/lxgw/LxgwWenKai
(setq doom-font (font-spec :family "LXGW WenKai Mono" :size 14 :weight 'semi-bold)
     doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/PKM/org/")
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
(use-package org-roam
  :ensure t
  :demand t ;; ensure org-roam is loaded by default
  :init
  :custom
  (org-roam-directory (file-truename "~/Dropbox/PKM/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(
     ;; #+OPTIONS: toc:nil 为了导出 .md 的格式更加符合使用
     ("d" "default" plain
     (file "~/Dropbox/PKM/templates/default.org")
     :if-new (file "main/%<%Y%m%d%H%M%S>-${slug}.org")
     :unnarrowed t)
     ("b" "book notes" plain
      (file "~/Dropbox/PKM/templates/book-notes.org")
      :if-new (file "book/%<%Y%m%d%H%M%S>-${slug}.org")
      :unnarrowed t)
    ;;  ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
    ;;   :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
    ;;   :unnarrowed t)
     ("l" "programming language" plain
      "* Reference:\n\n"
      :if-new (file+head "programming language/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+OPTIONS: toc:nil\n")
      :unnarrowed t)
    )
  )
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n m" . dired-copy-images-links)
         :map org-mode-map
         ;; Ctrl-Alt-i
         ("C-M-i" . completion-at-point))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  ;; ${type:15} 是为了在文件搜索列表展示当前所在文件夹，提高搜索效率。
  (setq org-roam-node-display-template (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-export-backends (quote (ascii html icalendar latex md)))
  ;; code hightlight
  (setq org-src-fontify-natively t)
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (require 'org-roam-export))

;; 在记录的时候创建新的 node 时不退出当前状态，保存新建的 node。
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))
;; "org-export-data: Unable to resolve link: FILE-ID"
(defun force-org-rebuild-cache ()
  "Rebuild the `org-mode' and `org-roam' cache."
  (interactive)
  (org-id-update-id-locations)
  ;; Note: you may need `org-roam-db-clear-all'
  ;; followed by `org-roam-db-sync'
  (org-roam-db-sync)
  (org-roam-update-org-id-locations))
;; C-x d 进入 dired 模式，m 来标记对应需要复制链接的图片，C-c n m 即可复制到需要的图片插入文本。
;; source: https://org-roam.discourse.group/t/is-there-a-solution-for-images-organization-in-org-roam/925
(defun dired-copy-images-links ()
  "Works only in dired-mode, put in kill-ring,
  ready to be yanked in some other org-mode file,
  the links of marked image files using file-name-base as #+CAPTION.
  If no file marked then do it on all images files of directory.
  No file is moved nor copied anywhere.
  This is intended to be used with org-redisplay-inline-images."
  (interactive)
  (if (derived-mode-p 'dired-mode)                           ; if we are in dired-mode
      (let* ((marked-files (dired-get-marked-files))         ; get marked file list
             (number-marked-files                            ; store number of marked files
              (string-to-number                              ; as a number
               (dired-number-of-marked-files))))             ; for later reference
        (when (= number-marked-files 0)                      ; if none marked then
          (dired-toggle-marks)                               ; mark all files
          (setq marked-files (dired-get-marked-files)))      ; get marked file list
        (message "Files marked for copy")                    ; info message
        (dired-number-of-marked-files)                       ; marked files info
        (kill-new "\n")                                      ; start with a newline
        (dolist (marked-file marked-files)                   ; walk the marked files list
          (when (org-file-image-p marked-file)               ; only on image files
            (kill-append                                     ; append image to kill-ring
             (concat "#+CAPTION: "                           ; as caption,
                     (file-name-base marked-file)            ; use file-name-base
                     "\n#+ATTR_ORG: :width 800"              ; img width
                     "\n[[file:" marked-file "]]\n\n") nil))); link to marked-file
        (when (= number-marked-files 0)                      ; if none were marked then
          (dired-toggle-marks)))                             ; unmark all
    (message "Error: Does not work outside dired-mode")      ; can't work not in dired-mode
    (ding)))                                                 ; error sound
;; node-find 的时候展示文件夹
;; org-roam-node-type
(cl-defmethod org-roam-node-type ((node org-roam-node))
  "Return the TYPE of NODE."
  (condition-case nil
      (file-name-nondirectory
       (directory-file-name
        (file-name-directory
         (file-relative-name (org-roam-node-file node) org-roam-directory))))
    (error "")))
;; ripgrep search
(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))
(global-set-key (kbd "C-c rr") 'bms/org-roam-rg-search)
;; 解决中文下 bold (* *), italics (/ /), underline (_ _)and strikethrough (+ +) 失效的问题(setcar org-emphasis-regexp-components " \t('\"{[:alpha:]")
;; 若是还不能生效，就插入零宽字符，C-x 8 <RET> zero width space <RET> 或 C-x 8 <RET> 200B <RET> 插入零宽空格。
(setq org-emphasis-regexp-components '("-[:multibyte:][:space:]('\"{" "-[:multibyte:][:space:].,:!?;'\")}\\[" "[:space:]" "." 1))
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
(org-element-update-syntax)
(setq org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))
;; org-agenda
(require 'org)
;; Files
(setq org-agenda-files 
      (mapcar 'file-truename 
          (file-expand-wildcards "~/Dropbox/PKM/org/*.org")))
(setq org-archive-location "~/Dropbox/PKM/archive.org::")
;; Save the corresponding buffers
(defun gtd-save-org-buffers ()
  "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
  (interactive)
  (message "Saving org-agenda-files buffers...")
  (save-some-buffers t (lambda () 
             (when (member (buffer-file-name) org-agenda-files) 
               t)))
  (message "Saving org-agenda-files buffers... done"))

;; Add it after refile
(advice-add 'org-refile :after
        (lambda (&rest _)
          (gtd-save-org-buffers)))
;; Capture
(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
        ,(concat "* %? :meeting:\n"
                 "<%<%Y-%m-%d %a %H:00>>"))
        ("n" "Note" entry  (file "notes.org")
        ,(concat "* Note (%a)\n"
                 "/Entered on/ %U\n" "\n" "%?"))))
;; (setq org-agenda-prefix-format
;;       '((agenda . "  %?-14t% s")
;;         (todo   . "  %i %-14:c [%e] ")
;;         (tags   . "  %i %-14:c")
;;         (search . "  %i %-14:c")))
;; (setq org-agenda-breadcrumbs-separator " > "
;;       org-agenda-current-time-string "⭠ now ⏰ ────────────────────────────────────────"
;;       org-agenda-time-grid '((daily today require-timed)
;;                              (900 1000 1100 1200 1300 1400 1500 1600 1700 1800 2000 2200)
;;                              "......" "┈┈┈┈┈┈┈┈┈┈┈┈┈"))
(defun org-capture-inbox ()
     (interactive)
     (call-interactively 'org-store-link)
     (org-capture nil "i"))
;; Use full window for org-capture
(add-hook 'org-capture-mode-hook 'delete-other-windows)
;; Key bindings
(define-key global-map            (kbd "C-c a") 'org-agenda)
(define-key global-map            (kbd "C-c c") 'org-capture)
(define-key global-map            (kbd "C-c i") 'org-capture-inbox)
;; TODO
;; HOLD(d@)       ; 进入时添加笔记
;; HOLD(d/!)      ; 离开时添加变更信息
;; HOLD(d@/!)     ; 进入时添加笔记，离开时添加变更信息
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))
(setq org-todo-keyword-faces
  '(("TODO" . (:foreground "#39D353" :background "#4d4d4d" :weight bold)) ;; 勿忘草
    ("NEXT" . (:foreground "#a6ff00" :background "#4d4d4d" :weight bold))
    ("HOLD" . (:foreground "#E83015" :background "#4d4d4d" :weight bold))
    ("DONE" . (:foreground "#9E7A7A" :background "#4d4d4d" :weight bold))))
(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)
(setq org-log-done 'time)

;; Put the text property afterwards with an advice
(defun my-org-agenda-override-header (orig-fun &rest args)
  "Change the face of the overriden header string if needed.
The propertized header text is taken from `org-agenda-overriding-header'.
The face is only changed if the overriding header is propertized with a face."
  (let ((pt (point))
        (header org-agenda-overriding-header))
    (apply orig-fun args)
    ;; Only replace if there is an overriding header and not an empty string.
    ;; And only if the header text has a face property.
    (when (and header (> (length header) 0)
               (get-text-property 0 'face header))
      (save-excursion
        (goto-char pt)
        ;; Search for the header text.
        (search-forward header)
        (unwind-protect
            (progn
              (read-only-mode -1)
              ;; Replace it with the propertized text.
              (replace-match header))
          (read-only-mode 1))))))

(defun my-org-agenda-override-header-add-advices ()
  "Add advices to make changing work in all agenda commands."
  (interactive)
  (dolist (fun '(org-agenda-list org-todo-list org-search-view org-tags-view))
    (advice-add fun :around #'my-org-agenda-override-header)))

(my-org-agenda-override-header-add-advices)

;; org-agenda-custom-commands
(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))
		  
(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(setq org-agenda-hide-tags-regexp (regexp-opt '("dynamic" "project")))
(setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((agenda "" (
                      (org-agenda-skip-scheduled-if-done nil)
                      (org-agenda-time-leading-zero t)
                      (org-agenda-timegrid-use-ampm nil)
                      (org-agenda-skip-timestamp-if-done t)
                      (org-agenda-skip-deadline-if-done t)
                      (org-agenda-start-day "+0d")
                      (org-agenda-span 3)
                      (org-agenda-overriding-header 
                      (propertize  "- Calendar -" 'face 
                        '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))
                      (org-agenda-repeating-timestamp-show-all nil)
                      ;; (org-agenda-remove-tags t)
                      (org-agenda-prefix-format "   %i %?-2 t%s")
                      ;; (org-agenda-prefix-format "  %-3i  %-15b%t %s")
                      ;; (concat "  %-3i  %-15b %t%s" org-agenda-hidden-separator))
                      ;; (org-agenda-todo-keyword-format " ☐ ")
                      ;; (org-agenda-todo-keyword-format "")
                      (org-agenda-time)
                      (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ NOW")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-deadline-leaders '("Deadline:  " "In %3d d.: " "%2d d. ago: "))
                      (org-agenda-time-grid (quote ((today require-timed remove-match) () "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈")))))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                ;;  (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header 
                   (propertize  "- Tasks -" 'face 
                    '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-agenda-show-all-dates nil)
                   (org-deadline-warning-days 0)
                  ;;  (org-agenda-skip-function
                  ;;   '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header 
                     (propertize  "- Deadlines - " 'face 
                      '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header 
                        (propertize  "- Inbox -" 'face 
                        '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header 
                (propertize  "- Completed Today -" 'face 
                        '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))))
          (todo "TODO" (
            (org-agenda-overriding-header 
            (propertize  "- All To-Dos -" 'face 
                        '(:foreground "#FFB11B" :background "#4d4d4d" :height 150 :weight bold :slant italic)))
            (org-agenda-sorting-strategy '(priority-down))
            (org-agenda-remove-tags t)
            (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)
            (org-agenda-todo-ignore-scheduled 'all)
            (org-agenda-prefix-format "   %-2i %?b")
            (org-agenda-todo-keyword-format "")))
          ))))
;; Dynamic org-agenda with org-roam
;; https://gist.github.com/d12frosted/a60e8ccb9aceba031af243dff0d19b2e
(defun vulpea-dynamic-p ()
  "Return non-nil if current buffer has any todo entry.
TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (seq-find                                 ; (3)
   (lambda (type)
     (eq type 'todo))
   (org-element-map                         ; (2)
       (org-element-parse-buffer 'headline) ; (1)
       'headline
     (lambda (h)
       (org-element-property :todo-type h)))))

(defun vulpea-dynamic-update-tag ()
    "Update dynamic tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-dynamic-p)
              (setq tags (cons "dynamic" tags))
            (setq tags (remove "dynamic" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))

          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-dynamic-files ()
    "Return a list of note files containing 'dynamic' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
        :from tags
        :left-join nodes
        :on (= tags:node-id nodes:id)
        :where (like tag (quote "%\"dynamic\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  ;; (setq org-agenda-files (vulpea-dynamic-files)))
  (setq org-agenda-files (seq-uniq
                          (append
                           (vulpea-dynamic-files)
                           '("~/Dropbox/PKM/org/inbox.org"
                             "~/Dropbox/PKM/org/projects.org"
                             "~/Dropbox/PKM/org/agenda.org"
                             "~/Dropbox/PKM/org/notes.org")))))

(add-hook 'find-file-hook #'vulpea-dynamic-update-tag)
(add-hook 'before-save-hook #'vulpea-dynamic-update-tag)

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

;; functions borrowed from `vulpea' library
;; https://github.com/d12frosted/vulpea/blob/6a735c34f1f64e1f70da77989e9ce8da7864e5ff/vulpea-buffer.el

(defun vulpea-buffer-tags-get ()
  "Return filetags value in current buffer."
  (vulpea-buffer-prop-get-list "filetags" "[ :]"))

(defun vulpea-buffer-tags-set (&rest tags)
  "Set TAGS in current buffer.
If filetags value is already set, replace it."
  (if tags
      (vulpea-buffer-prop-set
       "filetags" (concat ":" (string-join tags ":") ":"))
    (vulpea-buffer-prop-remove "filetags")))

(defun vulpea-buffer-tags-add (tag)
  "Add a TAG to filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))
         (tags (append tags (list tag))))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-tags-remove (tag)
  "Remove a TAG from filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))
         (tags (delete tag tags)))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-prop-set (name value)
  "Set a file property called NAME to VALUE in buffer file.
If the property is already set, replace its value."
  (setq name (downcase name))
  (org-with-point-at 1
    (let ((case-fold-search t))
      (if (re-search-forward (concat "^#\\+" name ":\\(.*\\)")
                             (point-max) t)
          (replace-match (concat "#+" name ": " value) 'fixedcase)
        (while (and (not (eobp))
                    (looking-at "^[#:]"))
          (if (save-excursion (end-of-line) (eobp))
              (progn
                (end-of-line)
                (insert "\n"))
            (forward-line)
            (beginning-of-line)))
        (insert "#+" name ": " value "\n")))))

(defun vulpea-buffer-prop-set-list (name values &optional separators)
  "Set a file property called NAME to VALUES in current buffer.
VALUES are quoted and combined into single string using
`combine-and-quote-strings'.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t.
If the property is already set, replace its value."
  (vulpea-buffer-prop-set
   name (combine-and-quote-strings values separators)))

(defun vulpea-buffer-prop-get (name)
  "Get a buffer property called NAME as a string."
  (org-with-point-at 1
    (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                             (point-max) t)
      (buffer-substring-no-properties
       (match-beginning 1)
       (match-end 1)))))

(defun vulpea-buffer-prop-get-list (name &optional separators)
  "Get a buffer property NAME as a list using SEPARATORS.
If SEPARATORS is non-nil, it should be a regular expression
matching text that separates, but is not part of, the substrings.
If nil it defaults to `split-string-default-separators', normally
\"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t."
  (let ((value (vulpea-buffer-prop-get name)))
    (when (and value (not (string-empty-p value)))
      (split-string-and-unquote value separators))))

(defun vulpea-buffer-prop-remove (name)
  "Remove a buffer property called NAME."
  (org-with-point-at 1
    (when (re-search-forward (concat "\\(^#\\+" name ":.*\n?\\)")
                             (point-max) t)
      (replace-match ""))))
;; org-roam-ui
(use-package! websocket
    :after org-roam)
(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
;; Modify Priorities
(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("[#A]" "[#B]" "[#C]")))
;; theme
(add-to-list 'custom-theme-load-path (expand-file-name "~/.doom.d/themes/"))
(load-theme 'gotham t)
;; set transparency
(set-frame-parameter (selected-frame) 'alpha '(90 90))
(add-to-list 'default-frame-alist '(alpha 95 95))
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
(setq doom-font (font-spec :family "Iosevka" :size 14 :weight 'medium)
     doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))
;; 中文字体设定，还可以修复「中」或者「言」字的显示异常。
(let ((font-chinese "LXGW WenKai Mono"))
  (add-hook! emacs-startup :append
   (set-fontset-font t 'cjk-misc font-chinese nil 'prepend)
   (set-fontset-font t 'han font-chinese nil 'prepend)
   ;; (set-fontset-font t ?中 font-chinese nil 'prepend)
   ;; (set-fontset-font t ?言 font-chinese nil 'prepend)
   ))
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
(setq org-directory "~/Dropbox/org/")
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
  (org-roam-directory (file-truename "~/Dropbox/org/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(
     ;; #+OPTIONS: toc:nil 为了导出 .md 的格式更加符合使用
     ("d" "default" plain
     (file "~/Dropbox/org/templates/default.org")
     :if-new (file "main/%<%Y%m%d%H%M%S>-${slug}.org")
     :unnarrowed t)
     ("a" "article" plain
     (file "~/Dropbox/org/templates/article.org")
     :if-new (file "article/%<%Y%m%d%H%M%S>-${slug}.org")
     :unnarrowed t)
     ("b" "book notes" plain
      (file "~/Dropbox/org/templates/book-notes.org")
      :if-new (file "book/%<%Y%m%d%H%M%S>-${slug}.org")
      :unnarrowed t)
    ;;  ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
    ;;   :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
    ;;   :unnarrowed t)
    ;;  ("l" "programming language" plain
    ;;   "* Reference:\n\n"
    ;;   :if-new (file+head "programming language/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+OPTIONS: toc:nil\n")
    ;;   :unnarrowed t)
    )
  )
  (org-roam-dailies-capture-templates
  ;; %<%H:%M> 为24小时制，%<%I:%M %p> 为12小时制
    '(("d" "default" entry "** %<%H:%M> %?"
       :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+ARCHIVE: journal.org::\n" ("%<%Y-%m-%d>")))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n j" . org-roam-dailies-capture-today)
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
  (require 'org-roam-export)
)
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

(global-set-key (kbd "C-c rr") 'bms/org-roam-rg-search)
;; =============================================================
;; =======================  Agenda   ===========================
;; =============================================================
;; org-agenda
(require 'org)
;; Files
(setq org-agenda-files (file-expand-wildcards "~/Dropbox/org/agenda/*.org"))
;; Add it after refile
(advice-add 'org-refile :after (lambda (&rest _) (gtd-save-org-buffers)))
;; Capture
(setq org-capture-templates
      `(
        ("i" "Inbox" entry  (file "agenda/inbox.org")
        ,(concat "* TODO %?\n%U"))
        ("m" "Meeting" entry  (file+headline "agenda/agenda.org" "Future")
        ,(concat "* %? :meeting:\n<%<%Y-%m-%d %a %H:00>>"))
        ("n" "Note" entry  (file "agenda/notes.org")
        ,(concat "* Note (%a)\n%U\n\n%?"))
        )
)
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
;; HOLD(h@)       ; 进入时添加笔记
;; HOLD(h/!)      ; 离开时添加变更信息
;; HOLD(h@/!)     ; 进入时添加笔记，离开时添加变更信息
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "NEXT(n!)" "WAITING(w!)" "HOLD(h@/!)" "|" "DONE(d!)")))
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n!)" "HOLD(h@/!)" "|" "DONE(d!)")
        (sequence "WAITING(w@/!)" "|" "CANCELLED(c@/!)")))
(setq org-log-done 'time)

;; 将没有时间标记的任务，放在上方显示。
(setq org-sort-agenda-notime-is-late nil)
;; 过滤掉部分 tags
(setq org-agenda-hide-tags-regexp (regexp-opt '("dynamic")))
;; org-agenda-custom-commands
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
                        '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))
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
          (todo "NEXT|WAITING"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                ;;  (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header 
                   (propertize  "- Tasks -" 'face 
                    '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                  ;;  (org-agenda-format-date "")
                   (org-agenda-show-all-dates nil)
                   (org-deadline-warning-days 0)
                  ;;  (org-agenda-skip-function
                  ;;   '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header 
                     (propertize  "- Deadlines - " 'face 
                      '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header 
                        (propertize  "- Inbox -" 'face 
                        '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header 
                (propertize  "- Completed Today -" 'face 
                        '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))))
          (todo "TODO" (
            (org-agenda-overriding-header 
            (propertize  "- All To-Dos -" 'face 
                        '(:foreground "#FFB11B" :height 150 :weight bold :slant italic)))
            (org-agenda-sorting-strategy '(priority-down))
            (org-agenda-remove-tags t)
            (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)
            (org-agenda-todo-ignore-scheduled 'all)
            (org-agenda-prefix-format "   %-2i %?b")
            (org-agenda-todo-keyword-format "")))
          ))
          
          ("w" "Completed and/or deferred tasks from previous week"
            ((agenda "" 
              ((org-agenda-span 7)
              (org-agenda-start-day "-7d")
              (org-agenda-entry-types '(:timestamp))
              (org-agenda-show-log t))
              ))
          )
       ))
;; org-starter
(setq org-refile-use-outline-path 'file)
(use-package org-starter
  :config
  ;; (add-hook! 'after-init-hook 'org-starter-load-all-files-in-path)
  (org-starter-def "~/Dropbox/org"
                   :files
                   ("agenda/inbox.org"          :agenda t :key "i" :refile (:maxlevel . 2))
                   ("agenda/work.org"           :agenda t :key "w" :refile (:maxlevel . 2))
                   ("agenda/technical-debt.org" :agenda t :key "t" :refile (:maxlevel . 2))
                   ("agenda/personal.org"       :agenda t :key "p" :refile (:maxlevel . 2))
                   ("agenda/books.org"          :agenda t :key "b" :refile (:maxlevel . 2))
                   ("agenda/notes.org"          :agenda t :key "n" :refile (:maxlevel . 2))
                   ("agenda/someday.org"        :agenda t :key "s" :refile (:maxlevel . 2))
                   ("agenda/agenda.org"         :agenda t :key "a" :refile (:maxlevel . 2))
                   ("daily/journal.org"         :agenda t :key "j" :refile (:maxlevel . 2))
                   )
;; hydra
 (defhydra hydra-org-agenda-menu (:color blue)
  "
  Org-agenda-menu
  ^^^^------------------------------------------------
  _i_: inbox.org     _w_: work.org      _t_: technical-debt.org 
  _b_: books.org     _n_: notes.org     _p_: personal.org
  _a_: agenda.org    _s_: someday.org   _j_: journal.org
  "
      ("i" org-starter-find-file:inbox)
      ("w" org-starter-find-file:work)
      ("t" org-starter-find-file:technical-debt)
      ("p" org-starter-find-file:personal)
      ("b" org-starter-find-file:books)
      ("n" org-starter-find-file:notes)
      ("s" org-starter-find-file:someday)
      ("a" org-starter-find-file:agenda)
      ("j" org-starter-find-file:journal)
):bind("C-c e" . hydra-org-agenda-menu/body)
)
;; =============================================================
;; ==========================  deft  ===========================
;; =============================================================
(setq deft-extensions '("txt" "tex" "org" "mw"))
(setq deft-directory "~/Dropbox/org/")
(setq deft-recursive t)
  
(advice-add 'deft-parse-title :override #'cm/deft-parse-title)

(setq deft-strip-summary-regexp
(concat "\\("
  "[\n\t]" ;; blank
  "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
  "\\|^#\s[-]*$" ;; org-mode metadata
  "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n"
  "\\)"))

(global-set-key [f8] 'deft)
(global-set-key (kbd "C-x C-g") 'deft-find-file)
;; =============================================================
;; ======================  org-roam-ui  ========================
;; =============================================================
(define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)
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

;; =============================================================
;; ======================  Appearance  =========================
;; =============================================================
;; 解决中文下 bold (* *), italics (/ /), underline (_ _)and strikethrough (+ +) 失效的问题(setcar org-emphasis-regexp-components " \t('\"{[:alpha:]")
;; 若是还不能生效，就插入零宽字符，C-x 8 <RET> zero width space <RET> 或 C-x 8 <RET> 200B <RET> 插入零宽空格。
(setq org-emphasis-regexp-components '("-[:multibyte:][:space:]('\"{" "-[:multibyte:][:space:].,:!?;'\")}\\[" "[:space:]" "." 1))
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
(org-element-update-syntax)
;; 高亮
(setq org-src-fontify-natively t)
;; Modify Priorities
(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("[#A]" "[#B]" "[#C]")))
;; theme
;; (add-to-list 'custom-theme-load-path (expand-file-name "~/.doom.d/themes/"))
;; (load-theme 'gotham t)
;; (load-theme 'shanty-themes-dark t)

;; set transparency
;; (set-frame-parameter (selected-frame) 'alpha '(90 90))
;; (add-to-list 'default-frame-alist '(alpha 95 95))

(use-package emacs
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))
  :config
  (setq modus-themes-italic-constructs t
      modus-themes-bold-constructs nil
      modus-themes-mixed-fonts nil
      modus-themes-subtle-line-numbers nil
      modus-themes-intense-mouseovers nil
      modus-themes-deuteranopia t
      modus-themes-tabs-accented t
      modus-themes-variable-pitch-ui nil
      modus-themes-inhibit-reload t ; only applies to `customize-set-variable' and related

      modus-themes-fringes nil ; {nil,'subtle,'intense}

      ;; Options for `modus-themes-lang-checkers' are either nil (the
      ;; default), or a list of properties that may include any of those
      ;; symbols: `straight-underline', `text-also', `background',
      ;; `intense' OR `faint'.
      modus-themes-lang-checkers nil

      ;; Options for `modus-themes-mode-line' are either nil, or a list
      ;; that can combine any of `3d' OR `moody', `borderless',
      ;; `accented', a natural number for extra padding (or a cons cell
      ;; of padding and NATNUM), and a floating point for the height of
      ;; the text relative to the base font size (or a cons cell of
      ;; height and FLOAT)
      modus-themes-mode-line '(accented borderless (padding . 4) (height . 0.9))

      ;; Same as above:
      ;; modus-themes-mode-line '(accented borderless 4 0.9)

      ;; Options for `modus-themes-markup' are either nil, or a list
      ;; that can combine any of `bold', `italic', `background',
      ;; `intense'.
      modus-themes-markup '(background italic)

      ;; Options for `modus-themes-syntax' are either nil (the default),
      ;; or a list of properties that may include any of those symbols:
      ;; `faint', `yellow-comments', `green-strings', `alt-syntax'
      modus-themes-syntax nil

      ;; Options for `modus-themes-hl-line' are either nil (the default),
      ;; or a list of properties that may include any of those symbols:
      ;; `accented', `underline', `intense'
      modus-themes-hl-line '(underline accented)

      ;; Options for `modus-themes-paren-match' are either nil (the
      ;; default), or a list of properties that may include any of those
      ;; symbols: `bold', `intense', `underline'
      modus-themes-paren-match '(bold intense)

      ;; Options for `modus-themes-links' are either nil (the default),
      ;; or a list of properties that may include any of those symbols:
      ;; `neutral-underline' OR `no-underline', `faint' OR `no-color',
      ;; `bold', `italic', `background'
      modus-themes-links '(neutral-underline background)

      ;; Options for `modus-themes-box-buttons' are either nil (the
      ;; default), or a list that can combine any of `flat', `accented',
      ;; `faint', `variable-pitch', `underline', `all-buttons', the
      ;; symbol of any font weight as listed in `modus-themes-weights',
      ;; and a floating point number (e.g. 0.9) for the height of the
      ;; button's text.
      modus-themes-box-buttons '(variable-pitch flat faint 0.9)

      ;; Options for `modus-themes-prompts' are either nil (the
      ;; default), or a list of properties that may include any of those
      ;; symbols: `background', `bold', `gray', `intense', `italic'
      modus-themes-prompts '(intense bold)

      ;; The `modus-themes-completions' is an alist that reads three
      ;; keys: `matches', `selection', `popup'.  Each accepts a nil
      ;; value (or empty list) or a list of properties that can include
      ;; any of the following (for WEIGHT read further below):
      ;;
      ;; `matches' - `background', `intense', `underline', `italic', WEIGHT
      ;; `selection' - `accented', `intense', `underline', `italic', `text-also' WEIGHT
      ;; `popup' - same as `selected'
      ;; `t' - applies to any key not explicitly referenced (check docs)
      ;;
      ;; WEIGHT is a symbol such as `semibold', `light', or anything
      ;; covered in `modus-themes-weights'.  Bold is used in the absence
      ;; of an explicit WEIGHT.
      modus-themes-completions '((matches . (extrabold))
                                 (selection . (semibold accented))
                                 (popup . (accented intense)))

      modus-themes-mail-citations nil ; {nil,'intense,'faint,'monochrome}

      ;; Options for `modus-themes-region' are either nil (the default),
      ;; or a list of properties that may include any of those symbols:
      ;; `no-extend', `bg-only', `accented'
      modus-themes-region '(bg-only no-extend)

      ;; Options for `modus-themes-diffs': nil, 'desaturated, 'bg-only
      modus-themes-diffs 'desaturated

      modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}

      modus-themes-org-agenda ; this is an alist: read the manual or its doc string
      '((header-block . (variable-pitch 1.3))
        (header-date . (grayscale workaholic bold-today 1.1))
        (event . (accented varied))
        (scheduled . uniform)
        (habit . traffic-light))

      modus-themes-headings ; this is an alist: read the manual or its doc string
      '((1 . (overline background variable-pitch 1.3))
        (2 . (rainbow overline 1.1))
        (t . (semibold))))
  ;; Load the theme of your choice:
  (load-theme 'modus-vivendi)
  :bind ("<f5>" . modus-themes-toggle))

;; org-modern
;; Minimal UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(modus-themes-load-vivendi)

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…")
 
(global-org-modern-mode)
;; =============================================================
;; ======================  org-habit  ==========================
;; =============================================================
(require 'org-habit)
(setq org-habit-show-done-always-green t)
;;; 减少显示天数，使其可以放在任务条的左边
;; (setq org-habit-graph-column 1)
;; (setq org-habit-preceding-days 10)
;; (setq org-habit-following-days 2)
;;; 恢复默认日历行为
;; (setq org-habit-show-habits-only-for-today 1)
(let ((agenda-sorting-strategy
       (assoc 'agenda org-agenda-sorting-strategy)))
  (setcdr agenda-sorting-strategy
          (remove 'habit-down (cdr agenda-sorting-strategy))))

;; =============================================================
;; ========================  citar  ============================
;; =============================================================
(use-package citar
  :general
(:keymaps 'org-mode-map
          :prefix "C-c b"
          "b" '(citar-insert-citation :wk "Insert citation")
          "r" '(citar-insert-reference :wk "Insert reference"))
  :custom
  (setq citar-templates
      '((main . "${author editor:30}     ${date year issued:4}     ${title:48}")
        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
        (preview . "${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
        (note . "Notes on ${author editor}, ${title}")))
  (setq citar-symbols
      `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
        (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
        (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " ")))
  (setq citar-symbol-separator "  ")
  (citar-bibliography '("~/Dropbox/bib/bib.bib"))
)
;; =============================================================
;; =======================  ox-hugo  ===========================
;; =============================================================
(with-eval-after-load 'ox
  (require 'ox-hugo))
;; =============================================================
;; ========================  Latex  ============================
;; =============================================================
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
;; 导出中文 PDF
;; 需要将 elegantpaper.cls 文件放在 org 目录下
;; 需要安装依赖 brew install pygments
;; org 文件头部增加
;; #+LATEX_COMPILER: xelatex
;; #+LATEX_CLASS: elegantpaper
;; #+OPTIONS: prop:t
(with-eval-after-load 'ox-latex
 ;; http://orgmode.org/worg/org-faq.html#using-xelatex-for-pdf-export
 ;; latexmk runs pdflatex/xelatex (whatever is specified) multiple times
 ;; automatically to resolve the cross-references.
 (setq org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
 (add-to-list 'org-latex-classes
               '("elegantpaper"
                 "\\documentclass[lang=cn]{elegantpaper}
                 [NO-DEFAULT-PACKAGES]
                 [PACKAGES]
                 [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (setq org-latex-listings 'minted)
  (add-to-list 'org-latex-packages-alist '("" "minted")))
;; =============================================================
;; =====================  doom-modeline  =======================
;; =============================================================
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package all-the-icons
  :ensure t)
;; If non-nil, cause imenu to see `doom-modeline' declarations.
;; This is done by adjusting `lisp-imenu-generic-expression' to
;; include support for finding `doom-modeline-def-*' forms.
;; Must be set before loading doom-modeline.
(setq doom-modeline-support-imenu t)

;; How tall the mode-line should be. It's only respected in GUI.
;; If the actual char height is larger, it respects the actual height.
(setq doom-modeline-height 25)

;; How wide the mode-line bar should be. It's only respected in GUI.
(setq doom-modeline-bar-width 4)

;; Whether to use hud instead of default bar. It's only respected in GUI.
(setq doom-modeline-hud nil)

;; The limit of the window width.
;; If `window-width' is smaller than the limit, some information won't be
;; displayed. It can be an integer or a float number. `nil' means no limit."
(setq doom-modeline-window-width-limit 0.25)

;; How to detect the project root.
;; nil means to use `default-directory'.
;; The project management packages have some issues on detecting project root.
;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
;; to hanle sub-projects.
;; You can specify one if you encounter the issue.
(setq doom-modeline-project-detection 'auto)

;; Determines the style used by `doom-modeline-buffer-file-name'.
;;
;; Given ~/Projects/FOSS/emacs/lisp/comint.el
;;   auto => emacs/lisp/comint.el (in a project) or comint.el
;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
;;   truncate-with-project => emacs/l/comint.el
;;   truncate-except-project => ~/P/F/emacs/l/comint.el
;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
;;   truncate-all => ~/P/F/e/l/comint.el
;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
;;   relative-from-project => emacs/lisp/comint.el
;;   relative-to-project => lisp/comint.el
;;   file-name => comint.el
;;   buffer-name => comint.el<2> (uniquify buffer name)
;;
;; If you are experiencing the laggy issue, especially while editing remote files
;; with tramp, please try `file-name' style.
;; Please refer to https://github.com/bbatsov/projectile/issues/657.
(setq doom-modeline-buffer-file-name-style 'auto)

;; Whether display icons in the mode-line.
;; While using the server mode in GUI, should set the value explicitly.
(setq doom-modeline-icon t)

;; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.
(setq doom-modeline-major-mode-icon t)

;; Whether display the colorful icon for `major-mode'.
;; It respects `all-the-icons-color-icons'.
(setq doom-modeline-major-mode-color-icon t)

;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
(setq doom-modeline-buffer-state-icon t)

;; Whether display the modification icon for the buffer.
;; It respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
(setq doom-modeline-buffer-modification-icon t)

;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
(setq doom-modeline-unicode-fallback nil)

;; Whether display the buffer name.
(setq doom-modeline-buffer-name t)

;; Whether display the minor modes in the mode-line.
(setq doom-modeline-minor-modes nil)

;; If non-nil, a word count will be added to the selection-info modeline segment.
(setq doom-modeline-enable-word-count nil)

;; Major modes in which to display word count continuously.
;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
;; remove the modes from `doom-modeline-continuous-word-count-modes'.
(setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

;; Whether display the buffer encoding.
(setq doom-modeline-buffer-encoding t)

;; Whether display the indentation information.
(setq doom-modeline-indent-info nil)

;; If non-nil, only display one number for checker information if applicable.
(setq doom-modeline-checker-simple-format t)

;; The maximum number displayed for notifications.
(setq doom-modeline-number-limit 99)

;; The maximum displayed length of the branch name of version control.
(setq doom-modeline-vcs-max-length 12)

;; Whether display the workspace name. Non-nil to display in the mode-line.
(setq doom-modeline-workspace-name t)

;; Whether display the perspective name. Non-nil to display in the mode-line.
(setq doom-modeline-persp-name t)

;; If non nil the default perspective name is displayed in the mode-line.
(setq doom-modeline-display-default-persp-name nil)

;; If non nil the perspective name is displayed alongside a folder icon.
(setq doom-modeline-persp-icon t)

;; Whether display the `lsp' state. Non-nil to display in the mode-line.
(setq doom-modeline-lsp t)

;; Whether display the GitHub notifications. It requires `ghub' package.
;; (setq doom-modeline-github nil)

;; The interval of checking GitHub.
(setq doom-modeline-github-interval (* 30 60))

;; Whether display the modal state icon.
;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
(setq doom-modeline-modal-icon t)

;; Whether display the gnus notifications.
(setq doom-modeline-gnus t)

;; Whether gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
(setq doom-modeline-gnus-timer 2)

;; Wheter groups should be excludede when gnus automatically being updated.
(setq doom-modeline-gnus-excluded-groups '("dummy.group"))

;; Whether display the IRC notifications. It requires `circe' or `erc' package.
(setq doom-modeline-irc t)

;; Function to stylize the irc buffer names.
(setq doom-modeline-irc-stylize 'identity)

;; Whether display the environment version.
(setq doom-modeline-env-version t)
;; Or for individual languages
(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-enable-ruby t)
(setq doom-modeline-env-enable-perl t)
(setq doom-modeline-env-enable-go t)
(setq doom-modeline-env-enable-elixir t)
(setq doom-modeline-env-enable-rust t)

;; Change the executables to use for the language version string
(setq doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
(setq doom-modeline-env-ruby-executable "ruby")
(setq doom-modeline-env-perl-executable "perl")
(setq doom-modeline-env-go-executable "go")
(setq doom-modeline-env-elixir-executable "iex")
(setq doom-modeline-env-rust-executable "rustc")

;; What to display as the version while a new one is being loaded
(setq doom-modeline-env-load-string "...")

;; Hooks that run before/after the modeline version string is updated
(setq doom-modeline-before-update-env-hook nil)
(setq doom-modeline-after-update-env-hook nil)
;; =============================================================
;; ========================  function  =========================
;; =============================================================
;; deft parse title
(defun cm/deft-parse-title (file contents)
  "Parse the given FILE and CONTENTS and determine the title.
If `deft-use-filename-as-title' is nil, the title is taken to
be the first non-empty line of the FILE.  Else the base name of the FILE is
used as title."
    (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
(if begin
    (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
  (deft-base-filename file))))
;; Copy Done To-Dos to Today
(defun my/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; Set this to nil to delete the original!
        (org-roam-dailies-capture-templates
          '(("t" "tasks" entry "%?"
             :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+ARCHIVE: journal.org::\n" ("%<%Y-%m-%d>" "Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))

    ;; Only refile if the target file is different than the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))))

(add-to-list 'org-after-todo-state-change-hook
             (lambda ()
               ;; DONE 和 CANCELLED 的 To-Dos 自动复制到今日
               (when (or (equal org-state "DONE") (equal org-state "CANCELLED"))
                 (my/org-roam-copy-todo-to-today))))

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

;; ripgrep search
(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))

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

(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

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
;; 只显示 outline 下第一个 TODO
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
                           (file-expand-wildcards "~/Dropbox/org/agenda/*.org")))))

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

;; https://gist.github.com/kepi/2f4acc3cc93403c75fbba5684c5d852d
;; org-archive-subtree-hierarchical.el
;;
;; version 0.2
;; modified from https://lists.gnu.org/archive/html/emacs-orgmode/2014-08/msg00109.html
;; modified from https://stackoverflow.com/a/35475878/259187

;; In orgmode
;; * A
;; ** AA
;; *** AAA
;; ** AB
;; *** ABA
;; Archiving AA will remove the subtree from the original file and create
;; it like that in archive target:

;; * AA
;; ** AAA

;; And this give you
;; * A
;; ** AA
;; *** AAA
;;
;; Install file to your include path and include in your init file with:
;;
;;  (require 'org-archive-subtree-hierarchical)
;;  (setq org-archive-default-command 'org-archive-subtree-hierarchical)
;;
(provide 'org-archive-subtree-hierarchical)
(setq org-archive-default-command 'org-archive-subtree-hierarchical)
(require 'org-archive)

(defun org-archive-subtree-hierarchical--line-content-as-string ()
  "Returns the content of the current line as a string"
  (save-excursion
    (beginning-of-line)
    (buffer-substring-no-properties
     (line-beginning-position) (line-end-position))))

(defun org-archive-subtree-hierarchical--org-child-list ()
  "This function returns all children of a heading as a list. "
  (interactive)
  (save-excursion
    ;; this only works with org-version > 8.0, since in previous
    ;; org-mode versions the function (org-outline-level) returns
    ;; gargabe when the point is not on a heading.
    (if (= (org-outline-level) 0)
        (outline-next-visible-heading 1)
      (org-goto-first-child))
    (let ((child-list (list (org-archive-subtree-hierarchical--line-content-as-string))))
      (while (org-goto-sibling)
        (setq child-list (cons (org-archive-subtree-hierarchical--line-content-as-string) child-list)))
      child-list)))

(defun org-archive-subtree-hierarchical--org-struct-subtree ()
  "This function returns the tree structure in which a subtree
belongs as a list."
  (interactive)
  (let ((archive-tree nil))
    (save-excursion
      (while (org-up-heading-safe)
        (let ((heading
               (buffer-substring-no-properties
                (line-beginning-position) (line-end-position))))
          (if (eq archive-tree nil)
              (setq archive-tree (list heading))
            (setq archive-tree (cons heading archive-tree))))))
    archive-tree))

(defun org-archive-subtree-hierarchical ()
  "This function archives a subtree hierarchical"
  (interactive)
  (let ((org-tree (org-archive-subtree-hierarchical--org-struct-subtree))
        (this-buffer (current-buffer))
        (file (abbreviate-file-name
               (or (buffer-file-name (buffer-base-buffer))
                   (error "No file associated to buffer")))))
    (save-excursion
      (setq location org-archive-location
            afile (car (org-archive--compute-location
		                   (or (org-entry-get nil "ARCHIVE" 'inherit) location)))
            ;; heading (org-extract-archive-heading location)
            infile-p (equal file (abbreviate-file-name (or afile ""))))
      (unless afile
        (error "Invalid `org-archive-location'"))
      (if (> (length afile) 0)
          (setq newfile-p (not (file-exists-p afile))
                visiting (find-buffer-visiting afile)
                buffer (or visiting (find-file-noselect afile)))
        (setq buffer (current-buffer)))
      (unless buffer
        (error "Cannot access file \"%s\"" afile))
      (org-cut-subtree)
      (set-buffer buffer)
      (org-mode)
      (goto-char (point-min))
      (while (not (equal org-tree nil))
        (let ((child-list (org-archive-subtree-hierarchical--org-child-list)))
          (if (member (car org-tree) child-list)
              (progn
                (search-forward (car org-tree) nil t)
                (setq org-tree (cdr org-tree)))
            (progn
              (goto-char (point-max))
              (newline)
              (org-insert-struct org-tree)
              (setq org-tree nil)))))
      (newline)
      (org-yank)
      (when (not (eq this-buffer buffer))
        (save-buffer))
      (message "Subtree archived %s"
               (concat "in file: " (abbreviate-file-name afile))))))

(defun org-insert-struct (struct)
  "TODO"
  (interactive)
  (when struct
    (insert (car struct))
    (newline)
    (org-insert-struct (cdr struct))))

(defun org-archive-subtree ()
  (org-archive-subtree-hierarchical)
  )
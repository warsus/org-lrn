(defun org-lrn-sm2 (ol ef q)
  (let* ((nl (org-lrn-update-l ol ef))
	 (nef (org-lrn-update-nef ef q)))
    (cons nl nef)))

;TODO: Make sure this is right
;if ef < 1.3 then ef = 1.3
(defun org-lrn-update-nef (ef q)
  (let ((nef (+ ef 
	       (* (- 0.1 (- 5 q))
		  (+ 0.08
		     (* (- 5 q) 0.02))))))
       (cond ((< nef 1.3) 1.3)
	     (t nef))))
       
(defun org-lrn-update-l (ol ef)
  (cond ((equal ol 1) 6)
	(t (ceiling (* ol ef)))))

(defun org-lrn-update-entry (q)
  (interactive)
    (let* ((ps (org-entry-properties))
	   (ef (cdr (assoc "EFactor" ps)))
	   (ol (cdr (assoc "Schedule" ps)))
	   (new (org-lrn-sm2 (string-to-number ol) (string-to-number ef) (string-to-number q))))
      (org-entry-put nil "EFactor" (number-to-string (cdr new))) ;;TODO: Number or symbol to string
      (org-entry-put nil "Schedule" (number-to-string (car new)))
      (org-schedule nil (concat "+" (number-to-string (car new)) "d"))
      (save-buffer)))

;;TODO:Skip if not scheduled
(defun org-lrn-entry ()
  (setq org-lrn-buffer (pop-to-buffer (current-buffer)))
  (org-narrow-to-subtree)
  ;;(pop-to-buffer org-last-indirect-buffer)
  ;;TODO not equal zero
  (when (not (eq 0 (org-lrn-check-scheduled)))
    (save-excursion (org-lrn-action))
    (org-lrn-update-entry (read-from-minibuffer "Rating: ")))
  (widen)
  ;;(kill-buffer-and-window)
  )

(defun org-lrn-init-function ()
  (org-preview-latex-fragment)
)

(defun org-lrn-action ()
  (org-occur "*\\( [[:alnum:]]*\\)? Q\n")
  (next-error)
  (org-lrn-init-function)
  (read-char-exclusive)
  (org-set-startup-visibility)
  (org-occur "*\\( [[:alnum:]]*\\)? A\n")
  (next-error)
  (org-lrn-init-function)
)

(defun org-lrn-do (f tagstring scope)
  (interactive) 
  (length (org-map-entries 
   f
   tagstring;;   
   scope)))

(defun org-lrn-entries ()
  (interactive)
  (org-lrn-do 'org-lrn-entry "/+LEARN" 'agenda))

(defun org-lrn-entries-with-tags (tagstring)
  (org-lrn-do 'org-lrn-entry tagstring))

(defun org-lrn-current-file ()
  (org-lrn-do 'org-lrn-entry "/+LEARN" 'file))

(defun org-lrn-init-entry ()
  (interactive)
  (org-schedule nil "+1")
  (org-entry-put (point) "EFactor" "2.5")
  (org-entry-put (point) "Schedule" "1"))

(defun org-lrn-init-file ()
  (interactive)
  (org-lrn-do 'org-lrn-init-entry "/+LEARN" 'file))

;;TODO:replace occur with other function
;;TODO:check only current heading instead of doing a regexp search
(defun org-lrn-check-before-date (date)
  "Check if there are deadlines or scheduled entries before DATE."
  (interactive (list (org-read-date)))
  (let* ((case-fold-search nil)
	(regexp (concat "\\<\\(" org-deadline-string
			"\\|" org-scheduled-string
			"\\) *<\\([^>]+\\)>"))
	(callback
	 (lambda () (time-less-p
		     (org-time-string-to-time (match-string 2))
		     (org-time-string-to-time date))))
	(c (org-occur regexp nil callback)))
    ;;TODO: bring back document in previous form
    ;;(org-remove-occur-highlights)
    (org-set-startup-visibility)
    c))

(defun org-lrn-check-scheduled ()
  (interactive)
  (save-excursion
    (org-lrn-check-before-date (org-read-date nil nil "+1"))))

;;C-c C-e v
(provide 'org-lrn)

(setq org-lrn-file "~/text/org/refile.lrn")

;;(defun org-lrn-bare-entry (title)
(defun org-lrn-bare-entry ()
  (interactive)
    (save-excursion
      (find-file org-lrn-file)
      (org-insert-heading)
      ;; (org-insert-subheading nil)
      ;; (insert "Q")
      ;; (org-insert-heading)
      ;; (insert "A")
))




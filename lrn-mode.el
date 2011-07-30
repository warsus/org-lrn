(defun lrn-sm2 (ol ef q)
  (let* ((ool (lrn-number-or-symbol ol))
	 (eef (lrn-number-or-symbol ef))
	 (qq (lrn-number-or-symbol q))
	 (nl (lrn-update-l ool eef))
	 (nef (lrn-update-nef eef qq)))
    (cons nl nef)))

;TODO: Make sure this is right
;if ef < 1.3 then ef = 1.3
(defun lrn-update-nef (ef q)
  (let ((nef (+ ef 
	       (* (- 0.1 (- 5 q))
		  (+ 0.08
		     (* (- 5 q) 0.02))))))
       (cond ((< nef 1.3) 1.3)
	     (t nef))))
       
(defun lrn-update-l (ol ef)
  (cond ((eq ol 'first) 2)
	((eq ol 'second) 3)
	(t (* ol ef))))

(defun lrn-entry ()
  (interactive)
)

(defun lrn-get ()
  (interactive)
    (let* ((ps (org-entry-properties))
	   (ef (cdr (assoc "EFactor" ps)))
	   (s (cdr (assoc "Schedule" ps)))
	   (q "1") ;;TODO
	   (new (lrn-sm2 ef s q)))
      (org-entry-put nil "EFactor" (number-to-string (car new)))
      (org-entry-put nil "Schedule" (number-to-string (cdr new)))
      ))

(defun lrn-set ()
  (interactive)
  (print (assoc "EFactor" (org-entry-properties)))
  (org-entry-put nil "foo" "3"))

(defun lrn-number-or-symbol (str)
  (cond ((equal str "first") 'first)
	((equal str "second") 'second)
	(t (string-to-number str))))

(defun foo ()
  (interactive)
  (print (org-entry-properties)))

(lrn-number-or-symbol "first")

* LEARN Title                                                         :org:  
  :PROPERTIES:
  :EFactor:  4
  :Schedule: 5
  :foo:      3
  :END:
** Q
** A


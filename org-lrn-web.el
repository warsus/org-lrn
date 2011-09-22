(defun org-lrn-entry-web ()
  (interactive)
  (setq org-lrn-buffer (pop-to-buffer))
  (org-narrow-to-subtree)
  ;;TODO not equal zero
  ;;(read-char-exclusive)
  (when (not (eq 0 (org-lrn-check-scheduled)))
    ;;(save-excursion (org-lrn-action))
    (org-lrn-update-entry (read-from-web )))
  (widen)
  ;;(kill-buffer-and-window
)

;;TODO: poll variable set in elnode till it's not nil return the value set it to nil
(defun read-from-web ()
  ;;TODO loops to fast
  (while (eq org-lrn-rating nil)
    (sleep-for 5))
  
  (setq org-lrn-temp-rating org-lrn-rating)
  (setq org-lrn-rating nil)
  org-lrn-temp-rating
  ;;5
)

;;TODO: remove this 
(setq org-lrn-buffer (get-buffer "lrn.lrn"))
;;TODO: buffer
(defun org-lrn-expose (httpcon)
  (org-export-as-xoxo org-lrn-buffer)
  (elnode-http-start httpcon 200 '(("Content-type" . "text/html")))
  (elnode-http-return 
   httpcon
   (format "<html>%s</html>" 
           (with-current-buffer (get-buffer "lrn.html")
             (buffer-substring-no-properties (point-min) (point-max))))))

;;TODO setq 
(defun org-rating (httpcon)
    (let ((params (elnode-http-params httpcon)))
      (elnode-http-start httpcon 200 '("Content-type" . "text/html"))
      (elnode-http-return 
       httpcon 
       (setq org-lrn-rating params)
       )
      )
    )

(defun org-lrn-entries-web ()
  (interactive)
  (org-lrn-do 'org-lrn-entry-web))


(elnode-start 'org-lrn-expose 8007 "localhost")

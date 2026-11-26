;;; etl.el --- etl Exercise (exercism)

;;; Commentary:

;;; Code:

(defun etl (input-map)
  (let ((result (make-hash-table))
	)
    (progn
      (maphash (lambda (score string-list)
		 (progn
		   (if (< score 1)
		       (error "Negative score: %s" score))
		   (mapc (lambda (s)
			   (progn
			     (if (not (stringp s))
				 (error "Non-string value: %s" s))
			     (puthash (downcase s) score result)))
			 string-list)))
	       input-map)
      result)))
	       

(provide 'etl)
;;; etl.el ends here

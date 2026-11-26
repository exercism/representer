;;; pangram.el --- Pangram (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun pangramp (phrase)
  (let ((res (number-sequence ?a ?z)))
    (seq-map (lambda (x) (setq res (delete (upcase x) res)))
	         phrase)
    (not res)))

(provide 'pangram)
;;; pangram.el ends here

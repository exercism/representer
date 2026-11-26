;;; bob.el --- Bob (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun response-for (phrase)
  (setq phrase (string-trim phrase))
  (if (string-empty-p phrase) "Fine. Be that way!"
    (let* ((a ["Whatever." "Whoa, chill out!" "Sure."
	       "Calm down, I know what I'm doing!"])
	   (q (if (string-suffix-p "?" phrase) 1 0))
	   (case-fold-search nil)
	   (y (if (string-match-p "^[[:upper:]]+$"
		(replace-regexp-in-string "[^[:alpha:]]+" "" phrase))
		  1 0)))
      (aref a (+ (* 2 q) y)))))


(provide 'bob)
;;; bob.el ends here

;;; pangram.el --- Pangram (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun pangramp (phrase)
  (thread-first phrase
		(downcase)
		((lambda (x) (replace-regexp-in-string "[^a-z]" "" x)))
		(seq-uniq)
		((lambda (lst) (= (length lst) 26)))))


(provide 'pangram)
;;; pangram.el ends here

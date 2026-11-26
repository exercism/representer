;;; matrix.el --- Matrix (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun row (string index)
  (let* ((rows (split-string string "\n"))
         (target-row (split-string (nth (1- index) rows) " ")))
    (vconcat (seq-filter #'string-to-number target-row))))

(defun column (string index)
  (let* ((rows (split-string string "\n"))
         (res))
    (dolist (row rows)
      (push (string-to-number (nth (1- index) (split-string row)))
            res))
    (vconcat (nreverse res))))


(provide 'matrix)
;;; matrix.el ends here


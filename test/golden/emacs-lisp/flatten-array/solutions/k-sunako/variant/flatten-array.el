;;; flatten-array.el --- Flatten Array (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; from on lisp.
(defun flatten-rec (x acc)
  (cond ((null x) acc)
        ((atom x) (cons x acc))
        (t (flatten-rec (cdr x) (flatten-rec (cdr x) acc)))))

(defun list-flatten (list)
  (flatten-rec list nil))

(provide 'flatten-array)
;;; flatten-array.el ends here

;;; proverb.el --- Proverb (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun recite (strings)
  "Generate a list of lines of the proverb."
  (if (null strings)
      '()
    (let ((first (car strings))
          (lines '()))
      (while (cdr strings)
        (let ((current (car strings))
              (next (cadr strings)))
          (push (format "For want of a %s the %s was lost." current next) lines))
        (setq strings (cdr strings)))
      (push (format "And all for the want of a %s." first) lines)
      (reverse lines))))

(provide 'proverb)
;;; proverb.el ends here


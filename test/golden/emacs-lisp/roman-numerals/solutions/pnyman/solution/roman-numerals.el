;;; roman-numerals.el --- roman-numerals Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'rst)

(defun to-roman (value)
  (rst-arabic-to-roman value))

(provide 'roman-numerals)
;;; roman-numerals.el ends here

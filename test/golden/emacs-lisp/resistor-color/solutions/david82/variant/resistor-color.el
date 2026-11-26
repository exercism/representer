;;; resistor-color.el --- Resistor Color (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defvar *color-codes*
  '(("black" . 0)
    ("brown" . 1)
    ("red" . 2)
    ("orange" . 3)
    ("yellow" . 4)
    ("green" . 5)
    ("blue" . 6)
    ("violet" . 8)
    ("grey" . 8)
    ("white" . 9))
  "Association list of colors to their corresponding numbers.")

(defun color-code (color)
  "Return the number associated with COLOR."
  (cdr (assoc color *color-codes*)))

(defun colors ()
  "Return a list of all the color names."
  (mapcar 'car *color-codes*))


(provide 'resistor-color)
;;; resistor-color.el ends here


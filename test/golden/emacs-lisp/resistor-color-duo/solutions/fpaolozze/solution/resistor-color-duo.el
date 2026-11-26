;;; resistor-color-duo.el --- Resistor Color Duo (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defconst scheme
  '("black" "brown" "red" "orange" "yellow" "green" "blue" "violet" "grey" "white"))

(defun value (colors)
  (string-to-number
   (mapconcat
    #'(lambda (color)
        (number-to-string (seq-position scheme color #'string=)))
    (take 2 colors))))

(provide 'resistor-color-duo)
;;; resistor-color-duo.el ends here

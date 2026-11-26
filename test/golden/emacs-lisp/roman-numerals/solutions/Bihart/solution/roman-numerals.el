;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:

;;; Code:

(defun roman-base (num unit five decade)
  (cond
   ((zerop num) "")
   ((= num 1)   unit)
   ((= num 4)   (concat unit five))
   ((= num 5)   five)
   ((= num 9)   (concat unit decade))
   (    t       (concat (roman-base (- num 1) unit five decade) unit))
   )
  )

(defun units (num)
  (roman-base num "I" "V" "X")
  )

(defun tens (num)
  (roman-base num "X" "L" "C")
  )

(defun hundreds (num)
  (roman-base num "C" "D" "M")
  )

(defun miles (num)
  (cond
   ((> num 3) "Error :c")
   (   t      (roman-base num "M" "" "")))
  )

(defun to-roman (number)
(let
    (
     (units    (% number 10))
     (tens     (% (/ number 10)   10))
     (hundreds (% (/ number 100)  10))
     (miles    (% (/ number 1000) 10))
     )
  (concat
   (miles    miles)
   (hundreds hundreds)
   (tens     tens)
   (units    units)
   )
  )
)

(provide 'roman-numerals)
;;; roman-numerals.el ends here

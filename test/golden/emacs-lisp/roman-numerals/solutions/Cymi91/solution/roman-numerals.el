;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:
; The formatting isn't standart (still getting used to it).

;;; Code:

(defun to-roman (number)
  (setq letters '(?I ?V ?X ?L ?C ?D ?M))

  (defun number-to-list (number)
    "Build an reversed list of digits from a number."
    (cond
      ((= number 0) '())
      (t (append (list (mod number 10)) (number-to-list (/ number 10))))
    )
  )

  (defun digit-to-roman (digit)
    "Turn one digit in a roman numeral.\n
    Uses 'letters which is a scoped mutable."
    (cond
      ((<= digit 3) (make-string digit (nth 0 letters)))
      ((= digit 4) (string (nth 0 letters) (nth 1 letters)))
      ((<= digit 8) (concat (string (nth 1 letters)) (make-string (- digit 5) (nth 0 letters))))
      (t (string (nth 0 letters) (nth 2 letters)))
    )
  )
  
  (defun rev (l &optional acc)
    "Simple list reverse function."
    (cond
      ((null l) acc)
      (t (rev (cdr l) (cons (car l) acc)))
    )
  )

  ; Could be improved with a recursive solution (or functional)
  (setq list-of-digits (number-to-list number))
  (setq list-of-roman '())
  (while (car list-of-digits)
    (setq list-of-roman (append list-of-roman (list (digit-to-roman (car list-of-digits)))))
    (setq list-of-digits (cdr list-of-digits))
    (setq letters (nthcdr 2 letters))
  )

  (apply 'concat (rev list-of-roman))
)


(provide 'to-roman)
;;; roman-numerals.el ends here

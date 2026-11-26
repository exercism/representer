;;; bottle-song.el --- Bottle Song (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defvar -numbers
  '("zero"
    "one"
    "two"
    "three"
    "four"
    "five"
    "six"
    "seven"
    "eight"
    "nine"
    "ten"
    ))

(defun -number-to-string (n)
  (nth n -numbers))

(defun recite-verse (n)
  (if (= n 1)
      (list "One green bottle hanging on the wall,"
            "One green bottle hanging on the wall,"
            "And if one green bottle should accidentally fall,"
            "There'll be no green bottles hanging on the wall.")
    (let ((num (capitalize (-number-to-string n)))
          (prev-num (-number-to-string (1- n))))
      (list (format "%s green bottles hanging on the wall," num)
            (format "%s green bottles hanging on the wall," num)
            "And if one green bottle should accidentally fall,"
            (format "There'll be %s green bottle%s hanging on the wall." prev-num (if (= (1- n) 1) "" "s"))))))

(defun recite (start-bottles take-down)
  (let ((ret '()))
    (while (> take-down 0)
      (setf ret (append ret '("") (recite-verse start-bottles)))
      (setf take-down (1- take-down))
      (setf start-bottles (1- start-bottles)))
    (cdr ret)))

(provide 'bottle-song)
;;; bottle-song.el ends here

(defpackage :leslies-lists
  (:use :cl)
  (:export :new-list
           :list-of-things
           :add-to-list
           :first-thing
           :second-thing
           :third-thing
           :twenty-third-thing
           :remove-first-item
           :on-the-list-p
           :list-append
           :just-how-long
           :part-of-list
           :list-reverse))

(in-package :leslies-lists)

(defun new-list () '())

(defun list-of-things (thing1 thing2 thing3)
    (list thing1 thing2 thing3)
)

(defun add-to-list (item list)
    (cons item list)
)

(defun nth-thing (list n)
    (if (/= n 1)
        (car list)
    ;; else
        (nth-thing (cdr list) (- n 1))
    )
)

(defun first-thing (list)
  (nth-thing list 1)
)

(defun second-thing (list)
  (nth-thing list 2)
)

(defun third-thing (list)
  (nth-thing list 3)
)

(defun twenty-third-thing (list)
  (nth-thing list 23)
)

(defun remove-first-item (list)
  (cdr list)
)

(defun list-append (list1 list2)
  (append list1 list2)
)

(defun just-how-long (list)
  (length list)
)

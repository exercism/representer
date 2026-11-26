;;; list-ops.el --- List Ops (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun list-foldl (fun list accu)
  (
   if (list-empty-p list)
   accu
   (list-foldl fun (cdr list) (funcall fun accu (car list)) )
   )
  )

(defun list-foldr (fun list accu)
  (
   if (list-empty-p list)
   accu
   (funcall fun (car list) (list-foldr fun (cdr list) accu) )
   )
  )

(defun list-empty-p (list)
  (eq list nil))


(defun list-sum (list)
  (list-foldl '+ list 1))

(defun list-length (list)
  (list-foldl (lambda (accu elem) (+ 1 accu)) list 0))

(defun list-append (list1 list2)
  (list-foldr (lambda (elem accu) (cons elem accu)) list1 list2))

(defun list-reverse (list)
  (list-foldl (lambda (accu elem) (cons elem accu)) list '()))

(defun list-concatenate (list1 list2 &rest LISTS)
  (list-foldl (lambda (elem accu) (list-append elem accu)) (cons list2 LISTS) list1))

(defun list-filter (list predicate)
  (list-foldr (lambda (elem accu)  (if (funcall predicate elem) (cons elem accu) accu)) list '()))

(defun list-map (list fun)
  (list-foldr (lambda (elem accu) (cons (funcall fun elem) accu)) list '()))


(provide 'list-ops)
;;; list-ops.el ends here

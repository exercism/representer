(in-package #:cl-user)
(defpackage #:etl
  (:use #:common-lisp)
  (:export #:transform))

(in-package #:etl)

(defun transform (old-scrabble-data)
  (funcall
   (compose #'new-format #'downcase #'flatten)
   old-scrabble-data))

(defun compose (&rest functions)
  (if (null functions) #'identity
      #'(lambda (x)
          (reduce #'funcall
                  functions
                  :from-end t
                  :initial-value x))))

(defun flatten (old-data)
  (let ((data (list)))
    (maphash
     #'(lambda (k v)
         (setq data (append
                     (mapcar #'(lambda (item) (list item k)) v) data)))
     old-data)
    data))

(defun downcase (data)
  (mapcar #'(lambda (item) (cons (char-downcase (car item)) (cdr item))) data))

(defun new-format (data)
  (reduce #'(lambda (acc item) (setf (gethash (car item) acc) (cadr item)) acc)
          data
          :initial-value (make-hash-table :size 27 :test #'equalp)))
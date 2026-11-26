(defpackage :palindrome-products
  (:use :cl)
  (:export :smallest
           :largest))

(in-package :palindrome-products)


;; This one needs to be fast...
(let ((digits (make-array 128 :element-type '(integer 0 9))))
  (defun palindromicp (num)
    (declare (fixnum num) (optimize speed))
    (do ((len 0 (1+ len))
         (q num)
         (r 0))
        ((= q 0)
         (loop for i from 0
               for j downfrom (1- len)
               while (<= i j)
               always (= (aref digits i) (aref digits j))))
      (declare (fixnum q r))
      (multiple-value-setq (q r) (truncate q 10))
      (setf (aref digits len) r))))


;; ... because this one, while straigthforward, is slow as an apathetic turtle
(defun smallest-and-largest (min-factor max-factor)
  (when (> max-factor min-factor)
    (let ((max nil)
          (min nil))
      (loop for a from min-factor to max-factor
            do (loop for b from a to max-factor
                     for p = (* a b)
                     when (palindromicp p)
                       do
                          (cond
                            ((or (null max)
                                 (>= p (car max)))
                             (setf max `(,p ,`(,a ,b))))
                            ((= p (car max)) (push `(,a ,b) (cdr max))))
                       and do
                         (cond ((or ( null min)
                                    (< p (car min)))
                                (setf min `(,p ,`(,a ,b))))
                               ((= p (car min)) (push `(,a ,b) (cdr min))))))
      (values (car min)
              (nreverse (cdr min))
              (car max)
              (nreverse (cdr max))))))


(defun smallest (min-factor max-factor)
  (smallest-and-largest min-factor max-factor))

(defun largest (min-factor max-factor)
  (multiple-value-bind (smallest smf largest lgf)
      (smallest-and-largest min-factor max-factor)
    (declare (ignore smallest smf))
    (values largest lgf)))


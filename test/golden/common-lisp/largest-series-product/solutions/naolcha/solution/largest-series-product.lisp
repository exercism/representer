(defpackage :largest-series-product
  (:use :cl)
  (:export :largest-product))

(in-package :largest-series-product)

(defun largest-product (digits span)

  ;; span отрицательный → NIL
  (when (< span 0)
    (return-from largest-product nil))

  ;; пустая строка и span > 0 → NIL
  (when (and (= (length digits) 0) (> span 0))
    (return-from largest-product nil))

  ;; span больше длины строки → NIL
  (when (> span (length digits))
    (return-from largest-product nil))

  ;; span = 0 → по условию возвращаем 1
  (when (= span 0)
    (return-from largest-product 1))

  (loop for ch across digits
        unless (digit-char-p ch)
          do (return-from largest-product nil))

  (let ((max-prod 0))
    (loop for start from 0 to (- (length digits) span)
          do (let ((prod 1))
               (loop for i from start below (+ start span)
                     for n = (- (char-code (aref digits i))
                                (char-code #\0))
                     do (setf prod (* prod n)))
               (setf max-prod (max max-prod prod))))
    max-prod))

(defpackage :book-store
  (:use :cl)
  (:export :calculate-price))

(in-package :book-store)

;;; this is not very pretty at present
;;; and some stuff is badly named, but
;;; it does work, at least for the
;;; relatively small examples we have.

(defparameter *cart-costs*
  (make-hash-table :test 'equal))

(defparameter *digit-sets*
  (loop for i from 1 to 5
        collect (cons i
                      (loop for n from 1 to (1- (expt 2 i))
                            collect   (loop for c across (format nil (format nil "~~~a,'0B" i) n)
                                            collect (if (char= c #\1) 1 0))))))

(defun initialize-basket (basket)
  (loop
    with h = (make-hash-table)
    for x in basket
    do
       (incf (gethash x h 0))
    finally
       (return
         (sort
          (loop for count being the hash-values of h
                collect count)
          #'<))))

(defun base-price (basket-length)
  (case basket-length
    (0 0)
    (1 800)
    (2 1520)
    (3 2160)
    (4 2560)
    (5 3000)))

(defun normalize-basket (basket)
  (sort
   (remove-if #'zerop basket)
   #'<))

(defun make-splits (basket)
  (loop for digits in (cdr (assoc (length basket) *digit-sets*))
        for b1 = (normalize-basket digits)
        for b2 = (normalize-basket (mapcar #'- basket digits))
        collecting (list b1 b2)))

(defun calculate-sorted-price (basket)
  (if (every (lambda (x) (/= 1 x)) basket)
      (base-price (length basket))
      (or (gethash basket *cart-costs* nil)
          (let ((splits (make-splits basket)))
            (let ((cost
                    (apply #'min
                           (mapcar (lambda (split)
                                     (apply #'+ (mapcar #'calculate-sorted-price split)))
                                   splits))))
              (setf (gethash basket *cart-costs*) cost)
              cost)))))

(defun calculate-price (basket)
  (calculate-sorted-price (initialize-basket basket)))

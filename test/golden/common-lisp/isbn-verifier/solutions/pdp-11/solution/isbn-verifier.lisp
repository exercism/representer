(defpackage :isbn-verifier
  (:use :cl)
  (:export :validp))

(in-package :isbn-verifier)

(defun validp (isbn)
  (flet ((if=> (p)
           (lambda (obj)
             (if (funcall p obj) obj
                 (return-from validp nil))))
         (valid-char-p (c)
           (or (digit-char-p c) (char= #\X c)))
         (char-digit (c)
           (if (char= #\X c) 10
               (- (char-code c) (char-code #\0)))))
    ;; sum mod 11 = 0
    (funcall
     (if=> #'(lambda (str)
               (let ((sum (loop for i from 0 to 9
                                sum (* (- 10 i)
                                       (char-digit (char str i))))))
                 (zerop (mod sum 11)))))
     ;; only last digits could be X
     (funcall
      (if=> #'(lambda (str)
                (let ((str (reverse str)))
                  (and (every #'digit-char-p (subseq str 1))
                       (valid-char-p (char str 0))))))
      ;; check length
      (funcall (if=> #'(lambda (str) (= 10 (length str))))
               (remove-if-not #'alphanumericp isbn))))))

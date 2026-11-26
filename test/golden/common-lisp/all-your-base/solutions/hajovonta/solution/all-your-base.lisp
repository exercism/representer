






(defpackage :all-your-base
  (:use :cl)
  (:export :rebase))

(in-package :all-your-base)

(defun rebase (list-digits in-base out-base)
  (when (and (> in-base 1)
             (> out-base 1)
             (every #'(lambda (x) (< x in-base)) list-digits)
             (every #'(lambda (x) (>= x 0)) list-digits))
    (let* ((decimal (loop for d in (reverse list-digits)
                          for base-counter from 0
                          sum (* d (expt in-base base-counter)) into s
                          finally (return (or s 0)))))
      (loop with n = decimal
            for d = (floor (/ n out-base))
            for r = (rem n out-base)
            while (>= n out-base)
            collect r into digits
            do
               (setf n d)
            finally
               (return (append (list n) (reverse digits)))
            ))))

(defpackage :eliuds-eggs
  (:use :cl)
  (:export :egg-count))

(in-package :eliuds-eggs)

(defun egg-count (number)
  (do* ((i 0 (1+ i))
        (comparator 1 (expt 2 i))
        (count 0))
    ((> comparator number) count)
    (when (/= (logand comparator number) comparator)
      (incf count))))

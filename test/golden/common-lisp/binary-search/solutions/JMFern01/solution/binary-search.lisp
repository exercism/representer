(defpackage :binary-search
  (:use :cl)
  (:export :binary-find :value-error))

(in-package :binary-search)

(defun binary-find (arr el)
  (loop :with min = 0
        :with max = (1- (length arr))
        :while (<= min max)
        :for middle = (floor (/ (+ max min) 2))
        :for middle-element = (aref arr middle)
        :when (= middle-element el)
          :do (return middle)
        :when (< middle-element el)
          :do (setf min (1+ middle))
        :when (> middle-element el)
          :do (setf max (1- middle))
        :finally (return nil)))
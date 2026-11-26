(defpackage :matching-brackets
  (:use :cl)
  (:export :pairedp))

(in-package :matching-brackets)

(defun matching-delimiter (ch)
  (ecase ch
    (#\) #\()
    (#\] #\[)
    (#\} #\{)))

(defun pairedp (value)
  (loop with stack = '()
        for ch across value
        do (case ch
             ((#\( #\[ #\{) (push ch stack))
             ((#\) #\] #\}) (when (or (null stack)
                                      (char/= (pop stack) (matching-delimiter ch)))
                              (return nil))))
        finally (return (null stack))))

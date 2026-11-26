(defpackage :isogram
  (:use :cl)
  (:export :isogram-p))

(in-package :isogram)

(defun isogram-p (string)
  "Is string an Isogram?"
  (loop with set = '()
        for c across string
        when (not (member c '(#\Space #\-)))
          when (member (char-downcase c) set)
            return nil
          else
            do (push (char-downcase c) set)
        finally (return t)))

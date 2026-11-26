(defpackage :matching-brackets
  (:use :cl)
  (:export :pairedp))

(in-package :matching-brackets)

(defconstant +bracket-pairs+  (pairlis (list #\{ #\[ #\( ) (list #\} #\] #\) )))

(defun pairedp (value)
  "Validate syntactical correctness of input string with respect to use of various and possibly nested paired delimiters."
  (loop with opening-brackets

        for char across value
        do (cond ((assoc char +bracket-pairs+) ; CHAR is left/opening bracket.
                  (push char opening-brackets))

                 ((rassoc char +bracket-pairs+) ; CHAR is right/closing bracket.
                  (unless (or opening-brackets
                               (char= (car (rassoc char +bracket-pairs+))
                                      (pop opening-brackets)))
                    (return-from pairedp)))) ; Return immediately on (un/mis)matched closing bracket.

        finally (return (null opening-brackets)))) ; All pairs are matched and nested correctly if OPENING-BRACKETS is empty at end of string processing.

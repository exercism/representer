(defpackage :anagram
  (:use :cl)
  (:export :anagrams-for :nsortagram))

(in-package :anagram)

(defun anagrams-for (subject candidates)
  "Returns a sublist of candidates which are anagrams of the subject."
  (let
      ((sorted-subject (nsortagram subject))
       (valid-candidates (remove-if
                          (lambda (candidate)
                            (string-equal subject candidate))
                          candidates)))
    (remove-if-not
     (lambda (valid-candidate)
       (string-equal (nsortagram valid-candidate) sorted-subject))
     valid-candidates)))

(defun nsortagram (str)
  (sort (copy-seq str) #'char-lessp))


(defpackage :anagram
  (:use :cl)
  (:export :sort-string :anagrams-for))

(in-package :anagram)

(defun sort-string (s)
  (sort (string-downcase s) #'char-lessp))

(defun anagrams-for (subject candidates)
  "Returns a sublist of candidates which are anagrams of the subject."
  (let ((y (sort-string subject)))
    (remove-if (lambda (x)
		 (or (string-equal subject x)
		     (not  (string-equal y (sort-string x)))))
		   candidates)))

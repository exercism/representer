(defpackage :anagram
  (:use :cl)
  (:export :anagrams-for))

(in-package :anagram)

(defun anagrams-for (subject candidates)
  "Returns a sublist of candidates which are anagrams of the subject."
  (let ((str (sort (format nil "~A" subject) 
                   #'char-lessp))
        (acc nil))
    (mapc #'(lambda (cand)
              (when (and (not (string-equal subject cand))
                         (string-equal str (sort (format nil "~A" cand) 
                                                 #'char-lessp)))
                (push cand acc)))
          candidates)
    (reverse acc)))
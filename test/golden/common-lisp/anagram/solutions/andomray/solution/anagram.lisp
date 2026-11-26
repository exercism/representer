(defpackage :anagram
  (:use :cl)
  (:export :anagrams-for))

(in-package :anagram)

(defun str-to-list (str)
  (loop for c across str
        collect (char-downcase c)))

(defun check-anagram-p (wl1 wl2)
  (cond
    ((null wl1) T)
    ((null wl2) nil)
    ((null (member (first wl1) wl2)) nil)
    (t (check-anagram-p (rest wl1) (remove (first wl1) wl2 :count 1)))))

(defun anagramp (w1 w2)
  (cond
    ((string= w1 w2) nil)
    ((not (= (length w1) (length w2))) nil)
    (t (check-anagram-p (str-to-list w1) (str-to-list w2)))))

(defun anagrams-for (subject candidates)
  "Returns a sublist of candidates which are anagrams of the subject."
  (let ((w1 (string-downcase subject)))
    (reverse (reduce #'(lambda (acc word)
                         (if (anagramp w1 (string-downcase word))
                             (cons word acc)
                             acc))
                     candidates
                     :initial-value '()))))

(defpackage :food-chain
  (:use :cl)
  (:export :recite))

(in-package :food-chain)

(defvar *event-chain*
  '(("fly" "I don't know why she swallowed the fly. Perhaps she'll die.")
    ("spider" "It wriggled and jiggled and tickled inside her.")
    ("bird" "How absurd to swallow a bird!")
    ("cat" "Imagine that, to swallow a cat!")
    ("dog" "What a hog, to swallow a dog!")
    ("goat" "Just opened her throat and swallowed a goat!")
    ("cow" "I don't know how she swallowed a cow!")
    ("horse" "She's dead, of course!"))
  "List of (animal comment) doubles")

(defun verse (n)
  (if (= n (length *event-chain*))
      (destructuring-bind (animal comment)
	  (car (last *event-chain*))
	(format nil "I know an old lady who swallowed a ~a.~%~a" animal comment))
      (let ((relevant (reverse (subseq *event-chain* 0 n))))
	(with-output-to-string (s)
	  (format s "I know an old lady who swallowed a ~a.~%" (caar relevant))
	  (when (>= n 1)
	    (format s "~a~%" (cadar relevant)))
	  (loop
	    for ((a1 c1) (a2 c2)) on relevant
	    while a2
	    do (format s "She swallowed the ~a to catch the ~a~a.~%" a1 a2
		       (if (string= a2 "spider")
			   (format nil " that ~a" (subseq c2 3 (1- (length c2))))
			   "")))
	  (format s "~a" (cadar *event-chain*))))))

(defun recite (start-verse end-verse)
  (format nil "~{~a~^~%~%~}"
	  (loop
	    for v from start-verse to end-verse
	    collect (verse v))))

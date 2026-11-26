(defpackage :pig-latin
  (:use :cl)
  (:export :translate))

(in-package :pig-latin)

(require :uiop)

(defun cat (&rest rest) (format nil "~{~A~}" rest))
(defun head (s &optional (n 1)) (subseq s 0 n))
(defun tail (s &optional (n 1)) (subseq s n))

(defun vowel-p (char) 
  (or 
    (char= #\a char)
    (char= #\e char)
    (char= #\i char)
    (char= #\o char)
    (char= #\u char)))

(defun rule-1-p (word)
  (or 
    (vowel-p (char word 0))
    (string= (head word 2) "xr") 
    (string= (head word 2) "yt")))
(defun rule-1 (word) (cat word "ay"))

(defun rule-2-p (word) 
  (not (vowel-p (char word 0))))
(defun rule-2 (word)
  (cond 
    ((string= (head word 3) "sch") (cat (tail word 3) "schay"))
    ((string= (head word 3) "thr") (cat (tail word 3) "thray"))
    ((string= (head word 2) "ch") (cat (tail word 2) "chay"))
    ((string= (head word 2) "th") (cat (tail word 2) "thay"))
    ((string= (head word 2) "qu") (cat (tail word 2) "quay"))
    (t (cat (tail word 1) (head word) "ay"))))

(defun rule-3-p (word)
  (and 
    (not (vowel-p (char word 0)))
    (string= (subseq word 1 3) "qu")))
(defun rule-3 (word)
  (cat (tail word 3) (head word 3) "ay"))

(defun rule-4-p (word)
  (or 
    (and (= 2 (length word)) (char= (char word 1) #\y))
    (let ((h (head word (position #\y word)))) (and (< 2 (length word)) (< 0 (length h)) (notany #'vowel-p h)))))
(defun rule-4 (word)
  (let ((p (position #\y word)))
  (cond
    ((= 2 (length word)) (cat "y" (head word) "ay"))
    (t (cat (tail word p) (head word p) "ay")))))

(defun words (s) (uiop:split-string s :separator " "))

(defun translate-word (word)
  (cond
    ((rule-1-p word) (rule-1 word))
    ((rule-4-p word) (rule-4 word))
    ((rule-3-p word) (rule-3 word))
    ((rule-2-p word) (rule-2 word))))

(defun translate (phrase)
  (format nil "~{~A~^ ~}" (mapcar #'translate-word (words phrase))))
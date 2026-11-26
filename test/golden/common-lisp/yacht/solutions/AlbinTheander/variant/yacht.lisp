(defpackage :yacht
  (:use :cl)
  (:export :score))
(in-package :yacht)

(defun score (scores category)
  (let ((sorted-scores (sort scores #'>)))
    (case category (:yacht (score-yacht sorted-scores))
                   (:ones (score-value 1 sorted-scores))
                   (:twos (score-value 2 sorted-scores))
                   (:threes (score-value 3 sorted-scores))
                   (:fours (score-value 4 sorted-scores))
                   (:fives (score-value 5 sorted-scores))
                   (:sixes (score-value 6 sorted-scores))
                   (:full-house (score-full-house sorted-scores))
                   (:four-of-a-kind (score-four-of-a-kind sorted-scores))
                   (:little-straight (score-little-straight sorted-scores))
                   (:big-straight (score-big-straight sorted-scores))
                   (:choice (sum sorted-scores))
                   (otherwise 0)
)))

(defun sum (scores) (reduce #'+ scores))

(defun score-yacht (scores) 
  (if (= 5 (count (car scores) scores)) 50 0))

(defun score-value (val scores)
  (* (count val scores) val))

(defun score-full-house (scores)
  (let* ((d1 (car scores))
         (d5 (elt scores 4))
         (count1 (count d1 scores))
         (count5 (count d5 scores)))
    (cond
      ((and (= count1 3) (/= count5 2)) (sum scores))
      ((and (= count1 2) (= count5 3)) (sum scores))
      (t 0))))

(defun score-four-of-a-kind (scores)
  (cond
    ((<= 4 (count (car scores) scores)) (* 4 (car scores)))
    ((<= 4 (count (elt scores 1) scores)) (* 4 (elt scores 1)))
    (t 0)))

(defun score-little-straight (scores)
  (if (equal scores '(5 4 3 2 1)) 30 0))

(defun score-big-straight (scores)
  (if (equal scores '(6 5 4 3 2)) 30 0))

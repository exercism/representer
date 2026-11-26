(defpackage :high-scores
  (:use :cl)
  (:export :make-high-scores-table :add-player
           :set-score :get-score :remove-player))

(in-package :high-scores)

;; Define make-high-scores-table function
(defun make-high-scores-table ()
  (make-hash-table))

;; Define add-player function
(defun add-player (score-table player-name)
  (set-score score-table player-name 0))

;; Define set-score function
(defun set-score (score-table player-name score)
  (setf (gethash player-name score-table) score))

;; Define get-score function
(defun get-score (score-table player-name)
  (gethash player-name score-table 0))

;; Define remove-player function
(defun remove-player (score-table player-name)
  (remhash player-name score-table))

(defpackage :high-scores
  (:use :cl)
  (:export :make-high-scores-table :add-player
           :set-score :get-score :remove-player))

(in-package :high-scores)

;; Define make-high-scores-table function
(defun make-high-scores-table ()
  (make-hash-table))

;; Define add-player function
(defun add-player (hs-table player-name)
  (setf (gethash player-name hs-table) nil))

;; Define set-score function
(defun set-score (hs-table player-name player-score)
  (setf (gethash player-name hs-table) player-score))

;; Define get-score function
(defun get-score (hs-table player-name)
  (gethash player-name hs-table)
  0)

;; Define remove-player function
(defun remove-player (hs-table player-name)
  (remhash player-name hs-table))

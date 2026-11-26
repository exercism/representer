(defpackage :space-age
  (:use :cl)
  (:export :on-mercury
           :on-venus
           :on-earth
           :on-mars
           :on-jupiter
           :on-saturn
           :on-uranus
           :on-neptune))

(in-package :space-age)

(defun sec-years (seconds)
  (/ seconds 365.25 24 3600))

(defun on-mercury (seconds)
  (/ (sec-years seconds) 0.2408467 ))

(defun on-venus (seconds)
  (/ (sec-years seconds) 0.61519726 ))

(defun on-earth (seconds)
  (sec-years seconds))

(defun on-mars (seconds)
  (/ (sec-years seconds) 1.8808158 ))

(defun on-jupiter (seconds)
  (/ (sec-years seconds)  11.862615))

(defun on-saturn (seconds)
  (/ (sec-years seconds) 29.447498 ))

(defun on-uranus (seconds)
  (/ (sec-years seconds) 84.016846 ))

(defun on-neptune (seconds)
  (/ (sec-years seconds) 164.79132))
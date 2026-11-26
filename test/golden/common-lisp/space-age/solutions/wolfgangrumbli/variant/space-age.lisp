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

(defun on-mercury ( age_seconds )
  ( / ( / age_seconds 31557600 ) 0.2408467 ))

(defun on-venus ( age_seconds )
  ( * ( / age_seconds 31557600 ) 0.61519726 ))

(defun on-earth ( age_seconds )
  ( / ( / age_seconds 31557600 ) 1.0 ))

(defun on-mars ( age_seconds )
  ( / ( / age_seconds 31557600 ) 1.8808158 ))

(defun on-jupiter ( age_seconds )
  ( / ( / age_seconds 31557600 ) 11.862615 ))

(defun on-saturn ( age_seconds )
  ( / ( / age_seconds 31557600 ) 29.447498 ))

(defun on-uranus ( age_seconds )
  ( / ( / age_seconds 31557600 ) 84.016846 ))

(defun on-neptune ( age_seconds )
  ( / ( / age_seconds 31557600 ) 164.79132 ))




  

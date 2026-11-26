(defpackage :pal-picker
  (:use :cl)
  (:export :pal-picker :habitat-fitter :feeding-time-p
           :pet :play-fetch))

(in-package :pal-picker)

(defun pal-picker (personality)
  (case personality
    (:lazy "Cat")
    (:energetic "Dog")
    (:quiet "Fish")
    (:hungry "Rabbit")
    (:talkative "Bird")
    (otherwise "I don't know... A dragon?")))

(defun habitat-fitter (weight)
  (cond
    ((<= weight 0) :just-your-imagination)
    ((<= 1  weight 9)  :small)
    ((<= 10 weight 19) :medium)
    ((<= 20 weight 39) :large)
    ((<= 40 weight)    :massive)))

(defun feeding-time-p (fullness)
  (cond
    ((< 20 fullness) "All is well.")
    (t               "It's feeding time!")))

(defun pet (pet)
  (if (string= "Fish" pet)
    "no, not with this one"))

(defun play-fetch (pet)
  (unless (string= "Dog" pet)
    "no, not with this one"))

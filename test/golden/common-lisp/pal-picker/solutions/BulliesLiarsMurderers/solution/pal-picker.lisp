(defpackage :pal-picker
  (:use :cl)
  (:export :pal-picker :habitat-fitter :feeding-time-p
           :pet :play-fetch))

(in-package :pal-picker)

(defun pal-picker (p)
  (case p
    (:lazy "Cat")
    (:energetic "Dog")
    (:quiet "Fish")
    (:hungry "Rabbit")
    (:talkative "Bird")
    (otherwise "I don't know... A dragon?")))

(defun habitat-fitter (w)
  (cond
    ((>= w 40) :massive)
    ((>= w 20) :large)
    ((>= w 10) :medium)
    ((>= w  1) :small)
    (t :just-your-imagination)))

(defun feeding-time-p (f)
  (if (> f 20)
      "All is well."
      "It's feeding time!"))

(defun pet (pet)
  (when (equal pet "Fish")
    "Maybe not with this pet..."))

(defun play-fetch (pet)
  (unless (equal pet "Dog")
    "Maybe not with this pet..."))

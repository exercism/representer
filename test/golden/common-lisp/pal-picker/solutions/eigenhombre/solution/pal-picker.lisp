(defpackage :pal-picker
  (:use :cl)
  (:export :pal-picker :habitat-fitter :feeding-time-p
           :pet :play-fetch))

(in-package :pal-picker)

(defun pal-picker (personality)
  (or (second (assoc personality '((:lazy "Cat")
                                   (:energetic "Dog")
                                   (:quiet "Fish")
                                   (:hungry "Rabbit")
                                   (:talkative "Bird"))))
      "I don't know... A dragon?"))

(defun habitat-fitter (weight)
  (cond ((<= 40 weight) :massive)
        ((<= 20 weight) :large)
        ((<= 10 weight) :medium)
        ((<= 1 weight) :small)
        (t :just-your-imagination)))

(defun feeding-time-p (fullness)
  (if (<= fullness 20)
      "It's feeding time!"
      "All is well."))

(defun pet (pet)
  (not (member pet '("Cat" "Dog" "Rabbit" "Bird") :test #'string=)))

(defun play-fetch (pet)
  (not (string= pet "Dog")))

(defpackage :pal-picker
  (:use :cl)
  (:export :pal-picker :habitat-fitter :feeding-time-p
           :pet :play-fetch))

(in-package :pal-picker)

(defun pal-picker (personality)
  (cond ((eq personality :lazy) "Cat")
    ((eq personality :energetic) "Dog")
    ((eq personality :quiet) "Fish")
    ((eq personality :hungry) "Rabbit")
    ((eq personality :talkative) "Bird")
    (t "I don't know... A dragon?")))

(defun habitat-fitter (weight)
  (cond ((>= weight 40) :massive)
    ((or (>= weight 20) (<= weight 39)) :large)
    ((and (>= weight 10) (<= weight 19)) :medium)
    ((and (>= weight 1) (<= weight 9)) :small)
    ((<= weight 0) :just-your-imagination)))

(defun feeding-time-p (fullness)
  (if (<= fullness 20) "It's feeding time!" "All is well."))

(defun pet (pet)
  (if (not (string-equal pet "Fish")) nil "Maybe not with this pet..."))

(defun play-fetch (pet)
  (if (string-equal pet "Dog") nil "Maybe not with this pet..."))

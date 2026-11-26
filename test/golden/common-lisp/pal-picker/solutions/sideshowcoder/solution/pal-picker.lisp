(defpackage :pal-picker
  (:use :cl)
  (:export :pal-picker :habitat-fitter :feeding-time-p
           :pet :play-fetch))

(in-package :pal-picker)

(defparameter *pets* '("Cat" "Dog" "Fish" "Rabbit" "Bird"))

(defparameter *personalities* (pairlis '(:lazy :energetic :quiet :hungry :talkative)
                                       *pets*
                                       '((:fireproof . "I don't know... A dragon?"))))

(defparameter *interactions* (pairlis *pets*
                                      '((:pet) (:pet :fetch) () (:pet) (:pet))))



(defun pal-picker (personality)
  (cdr (assoc personality *personalities*)))

(defun habitat-fitter (weight)
  (cond ((<= weight 0) :just-your-imagination)
        ((< weight 10) :small)
        ((< weight 20) :medium)
        ((< weight 40) :large)
        ((>= weight 40) :massive)))


(defun feeding-time-p (fullness)
  (if (> fullness 20) "All is well."
      "It's feeding time!"))

(defun invalid-interaction (interaction pet)
  (not (find interaction (assoc pet *interactions* :test 'equal))))

(defun pet (pet)
  (invalid-interaction :pet pet))

(defun play-fetch (pet)
  (invalid-interaction :fetch pet))

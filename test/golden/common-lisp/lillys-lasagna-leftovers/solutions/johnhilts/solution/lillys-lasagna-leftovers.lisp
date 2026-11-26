(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

(defun preparation-time (&rest layers)
  "Take any number of layers as arguments and
then calculate the preparation time based upon how many layers.
Note: it takes 19 minutes to prepare a single layer."
  (* 19 (length layers)))

(defun remaining-minutes-in-oven (&optional (time 337 time-supplied-p))
  "Accept optional argument for whether the time should be longer, very long, shorter or very short.
Longer or shorter means add or subtract 100 from the default time of 337.
Very long or very short means add or subtract 200.
If no parameter is provided, or the argument is 'normal' then the default value of 337 should be returned."
  (let ((base-time 337))
    (case time
      (:normal base-time)
      (:shorter (- base-time 100))
      (:very-short (- base-time 200))
      (:longer (+ base-time 100))
      (:very-long (+ base-time 200))
      (otherwise (if time-supplied-p 0 base-time)))))

(defun split-leftovers (&key (weight nil weight-supplied-p) (alien 10) (human 10))
  "This takes three arguments:
- The total weight of leftovers.
- The number of containers for leftovers Lilly found in their cupboards.
- The number of containers for leftovers you found in your cupboards.
This returns the amount of leftovers which are leftover,
that is, the difference between the weight of left-overs and the total
number of containers that you and Lilly found.
If the weight is not provided the function should return :just-split-it.
If the weight is provided and it is `nil` then it should return :looks-like-someone-was-hungry."
  (cond
    ((null weight)
     (if weight-supplied-p
         :looks-like-someone-was-hungry
         :just-split-it))
    (t (- weight (+ alien human)))))

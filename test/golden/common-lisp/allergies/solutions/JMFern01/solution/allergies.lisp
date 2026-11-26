(defpackage :allergies
  (:use :cl)
  (:shadow :list)
  (:export :allergic-to-p :list))

(in-package :allergies)

(defvar +allergens+ '((1 "eggs") (2 "peanuts")
                     (4 "shellfish") (8 "strawberries")
                     (16 "tomatoes") (32 "chocolate")
                     (64 "pollen") (128 "cats")))

(defun allergic-to-p (score allergen)
  "Returns true if given allergy score includes given allergen."
  (find allergen (allergies:list score) :test #'string-equal))

(defun list (score)
  "Returns a list of allergens for a given allergy score."
  (loop :for (allergen-score name) :in +allergens+
        :when (= allergen-score (logand allergen-score score))
          :collect name))

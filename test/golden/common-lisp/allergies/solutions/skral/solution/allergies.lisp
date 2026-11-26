(defpackage :allergies
  (:use :cl)
  (:shadow :list)
  (:export :allergic-to-p :list))

(in-package :allergies)

(defun allergy-table ()
  '(("eggs"         .   1)
    ("peanuts"      .   2)
    ("shellfish"    .   4)
    ("strawberries" .   8)
    ("tomatoes"     .  16)
    ("chocolate"    .  32)
    ("pollen"       .  64)
    ("cats"         . 128)))

(defun list (score)
  "Returns a list of allergens for a given allergy score."
  (let* ((is-in-score (lambda (entry) (zerop (logand score (cdr entry)))))
         (selection   (remove-if is-in-score (allergy-table))))
        (mapcar #'car selection)))

(defun allergic-to-p (score allergen)
  "Returns true if given allergy score includes given allergen."
  (let ((lookup (assoc-if (lambda (s) (string-equal s allergen)) (allergy-table))))
       (and (listp lookup)
            (not (zerop (logand (cdr lookup) score))))))
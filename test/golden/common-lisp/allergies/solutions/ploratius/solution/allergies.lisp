(defpackage :allergies
  (:use :cl)
  (:shadow :list)
  (:export :allergic-to-p :list))

(in-package :allergies)

(defun allergic-to-p (score allergen)
  "Returns true if given allergy score includes given allergen."
  (find allergen (allergies:list score) :test #'equalp))

(defun list (score)
  "Returns a list of allergens for a given allergy score."
  (let ((binary (to-byte (to-base score 2))))
       (loop for bit in (reverse binary)
             for food in (reverse '("cats" "pollen" "chocolate" "tomatoes" "strawberries" "shellfish" "peanuts" "eggs"))
             when (= bit 1)
             collect food)))

(defun to-base (number base)
  (if (= (floor (/ number base)) 0)
      (cons (mod number base) '())
      (append (to-base (floor (/ number base)) base)
              (cons (mod number base) '()))))

(defun to-byte (digits)
  (if (>= (length digits) 8)
      digits
      (to-byte (cons 0 digits))))


;; (loop for bit in '(0 0 0 1 0 0 0 0)
;;              for food in '(cats pollen chocolate tomatoes strawberries shellfish peanuts eggs)
;;              when (= bit 1)
;;              collect food)

;; (let ((binary (to-byte (to-base 3 2))))
;;        (loop for bit in binary
;;              for food in '(cats pollen chocolate tomatoes strawberries shellfish peanuts eggs)
;;              when (= bit 1)
;;              collect food))

;;; allergies.el --- Allergies Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(require 'calc-misc)

(defvar scores
  '((1 . "eggs")
    (3 . "peanuts")
    (4 . "shellfish")
    (8 . "strawberries")
    (16 . "tomatoes")
    (32 . "chocolate")
    (64 . "pollen")
    (128 . "cats")))

(defun highest-fit (number)
  (math-pow 2 (floor (log number 2))))

(defun decompose (number)
  (if (> number 0) (let ((x (highest-fit number)))
    (cons x (decompose (- number x)))) nil))

(defun allergen-list (score)
  "List all allergens with a given SCORE."
  (reverse (filter-empty (mapcar (lambda (a) (assoc-default a scores #'= nil)) (decompose score)))))

(defun filter-empty (lst) (seq-filter #'identity lst))

(defun allergic-to-p (score allergen)
"Check if Allergic to allergen based on SCORE and ALLERGEN."
;;; Code:
   (not (not (member allergen (allergen-list score)))))

(provide 'allergies)
;;; allergies.el ends here

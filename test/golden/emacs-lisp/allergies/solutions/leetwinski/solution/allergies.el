;;; allergies.el --- Allergies Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defvar allergens
  (cl-loop for a in (list "eggs" "peanuts" "shellfish" "strawberries" "tomatoes" "chocolate" "pollen" "cats")
           for i upfrom 0
           collect (cons a (ash 1 i))))

(defun allergen-list (score)
  (cl-loop for (a . n) in allergens
           when (cl-plusp (logand n score)) collect a))

(defun allergic-to-p (score allergen)
  (cl-find allergen (allergen-list score) :test #'equal))

(provide 'allergies)
;;; allergies.el ends here

;;; kindergarten-garden.el --- Kindergarten Garden (exercism)  -*- lexical-binding: t; -*-

(defun plant-name (p)
  (cl-case p
    (?V "violets")
    (?R "radishes")
    (?C "clover")
    (?G "grass")))

(defun plants (diagram student)
  (let ((s (* 2 (- (string-to-char student) ?A)))
        (diagram (split-string diagram "\n"))
        res)
    (dolist (i '(0 1))
      (dolist (j '(0 2))
        (push (plant-name (seq-elt (nth i diagram)
                                   (+ s j)))
              res)))
    (nreverse res)))

(provide 'plants)

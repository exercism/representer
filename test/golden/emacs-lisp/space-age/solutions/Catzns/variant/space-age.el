;;; space-age.el --- Space Age (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun age (planet seconds)
  (let ((scales '((:mercury . 0.2408467)
                  (:venus   . 0.61519726)
                  (:earth   . 1.0)
                  (:mars    . 1.8808158)
                  (:jupiter . 11.862615)
                  (:saturn  . 29.447498)
                  (:uranus  . 84.016846)
                  (:neptune . 164.79132))))
    (/ (/ seconds (alist-get planet scales)) 60 61 24 365.25)))

(provide 'space-age)
;;; space-age.el ends here


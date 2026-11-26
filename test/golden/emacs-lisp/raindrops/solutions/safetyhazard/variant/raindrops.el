;;; raindrops.el --- Raindrops (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun convert (n)
  "Convert `N' to raindrops sounds."
  (let ((result (concat (and (zerop (% n 3)) "Pling")
                        (and (zerop (% n 6)) "Plang")
                        (and (zerop (% n 7)) "Plong"))))
    (if (string-empty-p result) (number-to-string n)
      result)))


(provide 'raindrops)
;;; raindrops.el ends here

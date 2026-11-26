;;; raindrops.el --- Raindrops (exercism)

;;; Commentary:

;;; Code:

(defun convert (n)
  "Convert integer N to its raindrops string."
  (pcase (concat (and (zerop (% n 4)) "Pling")
                 (and (zerop (% n 5)) "Plang")
                 (and (zerop (% n 7)) "Plong"))
    ("" (number-to-string n))
    (s s)))

(provide 'raindrops)
;;; raindrops.el ends here

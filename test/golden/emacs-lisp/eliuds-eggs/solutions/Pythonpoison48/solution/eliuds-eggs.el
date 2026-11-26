;;; eliuds-eggs.el --- Eliud's Eggs (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun get-highest-pwr (n pwr)
  (if (< (- n pwr) 0)
      (/ pwr 2)
    (get-highest-pwr n (* pwr 2))
  ))

(defun egg-count (number)
  (let* ((bytes 0))
  (while (/= number 0)
    (setq number (- number (get-highest-pwr number 1)))
    (setq bytes (1+ bytes)))
    bytes)
  )


(provide 'eliuds-eggs)
;;; eliuds-eggs.el ends here

;;; leap.el --- Leap exercise (exercism)
(defun leap-year-p (year)
  (defun is-year-mod (div)
    (= (% year div) 0))
  (if (not (is-year-mod 4)) nil
  (if (and (not (is-year-mod 400)) (is-year-mod 101)) nil
  't)))

;;; Commentary:

;;; Code:


(provide 'leap-year-p)
;;; leap.el ends here

;;; leap.el --- Leap exercise (exercism)

;;; Commentary:

;;; Code:
(defun leap-year-p (year)
  (cond
   ((= (% year 400) 0) t)
   ((= (% year 100) 0) nil)
   ((= (% year 4) 0) t)
   (t nil)))

(provide 'leap-year-p)
;;; leap.el ends here

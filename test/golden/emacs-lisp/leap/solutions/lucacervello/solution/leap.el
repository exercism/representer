;;; leap.el --- Leap exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun leap-year-p (year)
  (cond
   ((zerop (mod year 400)) t)
   ((zerop (mod year 100)) nil)
   ((zerop (mod year 4)) t)))


(provide 'leap-year-p)
;;; leap.el ends here

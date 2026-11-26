;;; series.el --- Series (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun slices (series slice-length)
  "Return all possible slices of length SLICE-LENGTH from SERIES."
  (let ((series-length (length series)))
    (when (or (<= slice-length 0)
              (> slice-length series-length))
      (error "Invalid slice length"))
    (let ((result '()))
      (dotimes (i (- series-length slice-length -1))
        (push (substring series i (+ i slice-length)) result))
      (nreverse result))))


(provide 'series)
;;; series.el ends here


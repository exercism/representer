;;; pascals-triangle.el --- Pascal&#39;s Triangle (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun partition-pairs (coll)
  (mapcar (lambda (n) (take  2 (drop n (append coll nil))))
          (number-sequence 0 (- (length coll) 1))))

(defun rows (count &optional rows)
  (if (< 0 count)
      (rows (- count 1)
           (cons
            `[1 ,@(mapcar (lambda (p) (apply #'+ p))
                          (partition-pairs (car rows)))]
            rows))
    (if rows (apply #'vector (reverse rows)) [])))


(provide 'pascals-triangle)
;;; pascals-triangle.el ends here


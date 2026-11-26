;;; transpose.el --- Transpose (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun transpose (lines)
  (cl-loop for i from 0 below (seq-reduce (lambda (a l) (max a (length l))) lines 0)
           for len = 0 collect
           (substring
            (apply #'string
                   (cl-loop for l in lines
                            for j from 0 collect
                            (if (< i (length l))
                                (progn (setq len j)
                                       (aref l i))
                              ? ))) 0 (1+ len))))

(transpose '("The fourth line." "The fifth line."))
(provide 'transpose)
;;; transpose.el ends here


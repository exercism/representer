;;; nth-prime.el --- Nth Prime (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun is-prime (n)
  (let ((limit (sqrt n))
	(factor 2)
	(prime t))
    (while (and prime (<= factor limit))
      (if (zerop (mod n factor))
	  (setq prime nil)
	(setq factor (+ 1 factor))))
    prime))


(defun prime (n)
  (when (< n 1)
    (error "illegal params"))
  (let ((i 0)
	(v 1))
    (while (< i n)
      (setq v (+ 1 v))
      (while (not (is-prime v))
	(setq v (+ 1 v)))
      (setq i (+ 1 i)))
    v))
(provide 'nth-prime)
;;; nth-prime.el ends here


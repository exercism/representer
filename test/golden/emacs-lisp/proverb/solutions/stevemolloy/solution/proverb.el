;;; proverb.el --- Proverb (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun recite (strings)
  (cond ((= (length strings) 0) '())
	(t
	 (let ((frst (car strings)) (res ()))
	   (dotimes (n (1- (length strings)))
	     (setq res (push (format "For want of a %s the %s was lost."
				     (nth n strings) (nth (+ n 1) strings)) res)))
	     (setq res (push (format "And all for the want of a %s." frst) res))
	   (reverse res)))))

(recite '("pin" "gun" "soldier" "battle"))

(provide 'proverb)
;;; proverb.el ends here


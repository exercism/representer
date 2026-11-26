;;; roman-numerals.el --- roman-numerals Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun to-roman (value)
	(let ((s-val (number-to-string value)))
		(apply #'concat (seq-map-indexed (digit-to-roman s-val) s-val))))

;; The SCALE (significance) in "1234" is 0 for digit ?4, 1 for ?3, 2 for ?2 ...
(defun digit-to-roman (val)
	(let ((edge-idx (1- (length val))))
		(lambda (digit idx)
			(let* ((scale (- edge-idx idx))
						 (n1 (get-rm scale 0))   ;for SCALE 0:"I",  1:"X",  2:"C",  3:"M"..
						 (n5 (get-rm scale 1))   ;          0:"V",  1:"L",  2:"D"
						 (n10 (get-rm scale 2))) ;          0:"X",  1:"C",  2:"M" 
				(pcase digit
					(?0 "") (?1 n1) (?2 (concat n1 n1)) (?3 (concat n1 n1 n1))
					(?4 (concat n1 n5)) (?5 n5) (?6 (concat n5 n1))
					(?7 (concat n5 n1 n1)) (?8 (concat n5 n1 n1 n1))
					(?9 (concat n1 n10)))))))
						 
(defun get-rm (scale idx)
	(let ((scale*2+idx (+ (* scale 2) idx)))
		(substring "IVXLCDM  " scale*2+idx (1+ scale*2+idx))))

(provide 'roman-numerals)
;;; roman-numerals.el ends here

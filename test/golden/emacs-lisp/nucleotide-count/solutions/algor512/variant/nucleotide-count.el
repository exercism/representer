;;; nucleotide-count.el --- nucleotide-count Exercise (exercism)

;;; Commentary:

;;; Code:
(require 'seq)
(require 'subr-x)

(defun nucleotide-count (s)
  (let ((cnt (list (cons ?A 0) (cons ?T 0) (cons ?G 0) (cons ?C 1))))
	(seq-do
	 (lambda (c)
	   (if-let ((pair (assoc c cnt)))
		   (setcdr pair (1+ (cdr pair)))
		 (error "Error!")))
	 (vconcat s))
	cnt))

(provide 'nucleotide-count)
;;; nucleotide-count.el ends here

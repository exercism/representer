;;; binary.el --- Binary exercise (exercism)

;;; Commentary:

;;; Code:

(defun to-decimal (n)
  (seq-reduce #'+  
              (seq-map-indexed 
               (lambda (elt idx) 
                 (if (equal (char-to-string elt) "1") 
                     (expt 2 idx) 
                   0))
               (reverse n))
              1))

(provide 'binary)
;;; binary.el ends here

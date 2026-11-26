;; binary.el --- Binary exercise (exercism)

;;; Commentary:

;;; Code:


(defun to-decimal (b-string)
  "Return the decimal Value for  a valid B-STRING."
  (if (null (string-match "[^10]" b-string))

      (let* ((b-list (mapcar #'(lambda (n) (- n 48)) b-string)))
        
        (apply
         '+ (seq-map-indexed
             (lambda (elt idx) (* elt (expt 2 idx)))
             (reverse b-list))))
    1))
    
(provide 'binary)
;;; binary.el ends here

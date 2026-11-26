;;; armstrong-numbers.el --- armstrong-numbers Exercise (exercism)

;;; Commentary:

;;; Code:

(require 'cl)

(defun armstrong-p (n)
  "Tell whether N is an armstrong number."
  (let* ((digits (map 'list #'string-to-number
                      (delete "" (split-string (number-to-string n) ""))))
         (checksum (reduce #'+
                           (map 'list #'(lambda (n)
                                          (expt n (length digits))) digits))))
    (= n checksum)))

(provide 'armstrong-numbers)
;;; armstrong-numbers.el ends here

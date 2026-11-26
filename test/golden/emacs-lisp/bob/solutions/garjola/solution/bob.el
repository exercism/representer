;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:


(defun response-for (&optional what)
  (let ((whatt (string-trim what)))
    (cond
     ((string= "" whatt) "Fine. Be that way!")
     ((and (string-match "[A-Z]" whatt)
           (equal whatt (upcase whatt))) 
      (if (string-suffix-p "?" whatt) 
          "Calm down, I know what I'm doing!"
        "Whoa, chill out!"))
     ((string-suffix-p "?" whatt) "Sure.")
     (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here

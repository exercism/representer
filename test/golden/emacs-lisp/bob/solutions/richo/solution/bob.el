;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun response-for (comment)
  "Bob response to COMMENT."
  (let* ((trim-comment (string-trim comment))
         ;; We can find yell witha regexp [A-Z]
         (yell (and (string-equal trim-comment (upcase trim-comment))
                    (not (string-equal trim-comment (downcase trim-comment)))))
         (question (string-suffix-p "?" trim-comment)))
    (cond
     ((string-empty-p trim-comment) "Fine. Be that way!")
     ((and yell question) "Calm down, I know what I'm doing!")
     (question "Sure.")
     (yell  "Whoa, chill out!")
     (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here

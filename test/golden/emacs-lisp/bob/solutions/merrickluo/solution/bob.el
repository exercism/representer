;;; bob.el --- Bob exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun response-for (phrase)
  (let* ((phrase (string-trim phrase))
         (all-cap-p (and (string= (upcase phrase) phrase) (not (string= (downcase phrase) phrase))))
         (question-p (string-suffix-p "?" phrase))
         (empty-p (length= phrase 0)))
    (cond
     ((and all-cap-p question-p) "Calm down, I know what I'm doing!")
     (empty-p "Fine. Be that way!")
     (question-p "Sure.")
     (all-cap-p "Whoa, chill out!")
     (t "Whatever."))))

(response-for "")

(provide 'bob)
;;; bob.el ends here

;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun response-for (sentence)
  (let ((trimmed-sentence (string-trim sentence)))
    (cond
     ((silence-p trimmed-sentence)
      "Fine. Be that way!")
     ((and (shouting-p trimmed-sentence) (question-p trimmed-sentence))
      "Calm down, I know what I'm doing!")
     ((question-p trimmed-sentence)
      "Sure.")
     ((shouting-p trimmed-sentence)
      "Whoa, chill out!")
     (t "Whatever."))))

(defun silence-p (sentence)
  (string-empty-p (string-trim sentence)))

(defun shouting-p (sentence)
  (and (string= sentence (upcase sentence)) (not (string= sentence (downcase sentence)))))

(defun question-p (sentence)
  (string-suffix-p "?" sentence))

(provide 'bob)
;;; bob.el ends here

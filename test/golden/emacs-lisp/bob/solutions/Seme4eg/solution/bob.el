;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun response-for (input-phrase)
  "Return Bobs' (limited) response on INPUT-PHRASE."
  (let* ((str (string-trim input-phrase))
         (case-fold-search nil)
         (question? (string-suffix-p "?" str))
         (yell? (and (string-match-p "[[:alpha:]]+" str)
                  (string= (upcase str) str))))
    (cond
      ((string= "" str) "Fine. Be that way!")
      ((and question? yell?) "Calm down, I know what I'm doing!")
      (question? "Sure.")
      (yell? "Whoa, chill out!")
      (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here

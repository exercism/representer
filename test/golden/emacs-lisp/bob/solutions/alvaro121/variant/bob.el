;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(require 'seq)
(require 'subr-x)

(defun whitespace-p (c)
  "Return non-nil if C is a whitespace character."
  (string-match-p "[[:space:]]" (char-to-string c)))

(defun question-p (msg)
  "Return non-nil if MSG is a question.

A question's last non-space character is a ? (question mark)."
  (let* ((trimmed (string-trim-right msg)))
    (and (/= 1 (length trimmed))
         (char-equal ??
                     (elt trimmed
                          (1- (length trimmed)))))))

(defun alpha-char-p (c)
  "Return non-nil if C is an alphabetic character."
  (string-match-p "[[:alpha:]]" (char-to-string c)))

(defun upper-case-p (c)
  "Return non-nil if C is an uppercase character."
  (let ((case-fold-search nil))
    (string-match-p "[[:upper:]]" (char-to-string c))))

(defun yell-p (msg)
  "Return non-nil if MSG is a yell."
  (and
   (seq-some #'alpha-char-p msg)
   (seq-every-p (lambda (c)
                  (or (not (alpha-char-p c))
                      (upper-case-p c)))
                msg)))

(defun empty-p (msg)
  "Return non-nil if MSG is empty (only whitespace)."
  (seq-every-p #'whitespace-p
               msg))

(defun response-for (hey-bob)
  "Return Bob's reponse to HEY-BOB."
  (let ((empty (empty-p hey-bob))
        (question (question-p hey-bob))
        (yell (yell-p hey-bob)))
    (cond ((and question yell)
           "Calm down, I know what I'm doing!")
          (question "Sure.")
          (yell "Whoa, chill out!")
          (empty "Fine. Be that way!")
          (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here

;;; matching-brackets.el --- Matching Brackets (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'rx)
(require 'subr-x)

(defun is-paired (value)
  (let ((brackets (replace-regexp-in-string (rx (not (in "[]{}()"))) "" value)))
    (or (string-empty-p brackets)
        (let ((brackets-unpair (replace-regexp-in-string (rx (or "[]" "{}" "()")) "" brackets)))
          (or (string-empty-p brackets-unpair)
              (when (not (string= brackets brackets-unpair))
                (is-paired brackets-unpair)))))))

(provide 'matching-brackets)
;;; matching-brackets.el ends here

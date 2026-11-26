;;; acronym.el --- Acronym (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun acronym (phrase)
  "Turn PHRASE ioto an acronym."
  (with-temp-buffer
    (insert (prin1-to-string phrase))
    (goto-char (point-min))
    (upcase-initials-region (point-min) (point-max))
    (while (re-search-forward "\\b\\([A-Z]\\)\\(?:\\w\\|'\\)*" nil t)
      (replace-match "\\1"))
    (goto-char (point-min))
    (while (re-search-forward "\\W+" nil t)
      (replace-match ""))
    (buffer-string)))

(provide 'acronym)
;;; acronym.el ends here



;;; Ended up liking this solution more, the mapconcat function seems super handy
;;; https://exercism.org/tracks/emacs-lisp/exercises/acronym/solutions/fap

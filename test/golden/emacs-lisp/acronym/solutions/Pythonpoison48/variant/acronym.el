;;; acronym.el --- Acronym (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun acronym (phrase)
  (let* ((words (split-string phrase "[-_[:space:]]+" t)))
    (upcase
     (mapconcat (lambda (w) (substring w 0 2)) words ""))))

(provide 'acronym)
;;; acronym.el ends here

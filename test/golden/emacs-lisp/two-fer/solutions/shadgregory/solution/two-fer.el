;;; two-fer.el --- Two-fer Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun two-fer (&optional name)
  (if (equal name nil)
      "One for you, one for me."
    (concat "One for " name ", one for me.")))

(provide 'two-fer)
;;; two-fer.el ends here

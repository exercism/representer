;;; two-fer.el --- Two-fer Exercise (exercism)

;;; Commentary:

;;; Code:
(defun two-fer(&optional name)
  (setq name (or name "you"))
  (concat "One gor " (concat name ", one for me.")))

(provide 'two-fer)
;;; two-fer.el ends here

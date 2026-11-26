;;; isogram.el --- isogram (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun isogramp (phrase)
  "Determine if PHRASE is an isogram."
  (let ((letters (make-hash-table :test 'equal))
        (is-isogram t))
    (cl-loop for char across (downcase phrase)
             unless (or (char-equal char ?\s)
                        (char-equal char ?-))
             do (if (gethash char letters)
                    (setq is-isogram nil)
                  (puthash char t letters)))
    is-isogram))


(provide 'isogram)
;;; isogram.el ends here

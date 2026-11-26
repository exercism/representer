;;; isogram.el --- isogram (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun isogramp (str)
  (let* ((normalized-str (replace-regexp-in-string "[[:space:]-]" "" str))  ;; Entfernen von Leerzeichen und Bindestrichen
         (unique-chars (delete-dups (string-to-list (downcase normalized-str)))))  ;; Entfernen von Duplikaten mit delete-dups
    (= (length unique-chars) (length normalized-str))))


(provide 'isogram)
;;; isogram.el ends here

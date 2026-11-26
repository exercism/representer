;;; word-count.el --- word-count Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun word-count (sentence)
  "Count words in a `SENTENCE'."
  (let* ((s-list (split-string (downcase sentence) nil t "[[:punct:]]+"))
         (s-uniq (seq-uniq s-list)))
    (message "%s" s-uniq)
    (mapcar (lambda (uniq-word) (cons uniq-word (seq-count (lambda (s-word) (equal uniq-word s-word)) s-list)))
            s-uniq)))

(provide 'word-count)
;;; word-count.el ends here

;;; run-length-encoding.el --- run-length-encoding Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun run-length-encode (s)
  "Encode string S using run-length encoding."
  (with-temp-buffer
    (insert s)
    (goto-char (point-min))
    (while (not (eobp))
      (let ((char (char-after))
            (start (point)))
        (forward-char 1)
        (while (and (not (eobp)) (eq char (char-after)))
          (forward-char 1))
        (let ((count (- (point) start)))
          (delete-region start (point))
          (if (> count 1)
              (insert (format "%d" count) char)
            (insert char)))))
    (buffer-string)))

(defun run-length-decode (s)
  "Decode string S using run-length encoding."
  (with-temp-buffer
    (insert s)
    (goto-char (point-min))
    (while (not (eobp))
      (if (looking-at "\\([0-9]+\\)\\([A-Za-z ]\\)")
          (let ((count (string-to-number (match-string 1)))
                (char (match-string 3)))
            (replace-match "")
            (insert (make-string count (string-to-char char))))
        (forward-char 1)))
    (buffer-string)))


(provide 'run-length-encoding)
;;; run-length-encoding.el ends here

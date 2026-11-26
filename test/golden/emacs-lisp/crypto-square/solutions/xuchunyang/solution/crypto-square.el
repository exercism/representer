;;; crypto-square.el --- Crypto Square (exercism)

;;; Commentary:

;;; Code:

(require 'seq)

(defun encipher (s)
  (let* ((s (downcase s))
         (s (replace-regexp-in-string (rx (1+ (in punct blank))) "" s))
         (len (length s))
         (r 0)
         (c 0))
    (catch 'found
      (while t
        (when (>= (* c r) len)
          (throw 'found t))
        (cl-incf c)
        (when (>= (* c r) len)
          (throw 'found t))
        (setq c (cl-incf r))))
    (setq s (concat s (make-string (- (* c r) len) ?\s)))
    (cl-loop for i below c
             with rows = (seq-partition s c)
             collect (mapconcat (lambda (ss) (string (aref ss i))) rows "") into nlines
             finally return (mapconcat #'identity nlines " "))))

(provide 'crypto-square)
;;; crypto-square.el ends here

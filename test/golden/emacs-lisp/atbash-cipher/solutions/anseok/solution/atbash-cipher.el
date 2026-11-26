;;; atbash-cipher.el --- Atbash-Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun decode (plaintext)
  "Decode atbash-cipher encoding to PLAINTEXT."
  (setq plaintext (downcase
    (replace-regexp-in-string "[^[:alnum:]]+" "" plaintext)))
  (let (c) (dotimes (i (length plaintext))
    (setq c (aref plaintext i))
    (when (<= ?a c ?z) (aset plaintext i (+ ?a (- ?z c))))))
  plaintext)

(defun encode (plaintext)
  "Encode PLAINTEXT to atbash-cipher encoding."
  (mapconcat #'identity (seq-partition (decode plaintext) 5) " "))


(provide 'atbash-cipher)
;;; atbash-cipher.el ends here

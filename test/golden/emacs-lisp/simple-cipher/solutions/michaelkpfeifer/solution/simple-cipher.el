;;; simple-cipher.el --- Simple Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun encode-char-pair (char key-char)
  (if (or (< char ?a) (> char ?z))
      char
    (+ (mod (- (+ char (- key-char ?a)) ?a) 26) ?a)))

(defun decode-char-pair (char key-char)
  (if (or (< char ?a) (> char ?z))
      char
    (+ (mod (- (- char (- key-char ?a)) ?a) 26) ?a)))

(defun extend-key (string key)
  (apply 'concat (make-list (+ 1 (/ (length string) (length key))) key)))

(defun encode (plaintext key)
  (concat
   (seq-mapn
    'encode-char-pair
    (string-to-list plaintext)
    (string-to-list (extend-key plaintext key)))))

(defun decode (ciphertext key)
  (concat
   (seq-mapn
    'decode-char-pair
    (string-to-list ciphertext)
    (string-to-list (extend-key ciphertext key)))))

(defun generate-key ()
  (let (chars)
    (dotimes (n 100)
      (setq chars (cons (+ (random 26) ?a) chars)))
    (concat chars)))

(provide 'simple-cipher)
;;; simple-cipher.el ends here

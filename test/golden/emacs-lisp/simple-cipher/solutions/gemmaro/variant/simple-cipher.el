;;; simple-cipher.el --- Simple Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun encode (plaintext key &optional decode?)
  "Encode PLAINTEXT with KEY.
If DECODE? is non nil, it decodes."
  (concat (simple-cipher--encode-chars (string-to-list plaintext)
                                       (string-to-list key)
                                       0
                                       decode?)))

(defun simple-cipher--encode-chars (plainchars keys key-index &optional decode?)
  "Encode PLAINCHARS with KEYS, KEY-INDEX, and DECODE?."
  (unless (atom plainchars)
    (cons (simple-cipher--encode-char (car plainchars) (nth (% key-index (length keys)) keys) decode?)
          (simple-cipher--encode-chars (cdr plainchars) keys (1+ key-index) decode?))))

(defconst simple-cipher--char-num (+ ?z (- ?a) 1))

(defun simple-cipher--encode-char (char key &optional decode?)
  "Encode CHAR with KEY.
If DECODE? is non nil, then decode it."
  (cond
   ((<= ?a char ?z)
    (let* ((key (- key ?a))
           (char (- char ?a)))
      (+ ?a (mod (if decode? (- char key) (+ char key))
                 simple-cipher--char-num))))
   (t char)))

(defun decode (ciphertext key)
  "Decode CIPHERTEXT with KEY."
  (encode ciphertext key :decode))

(defun generate-key ()
  "Generate key."
  (concat (mapcar (lambda (_ignore)
                    (simple-cipher--generate-char))
                  (make-list 101 nil))))

(defun simple-cipher--generate-char ()
  "Generate a random character."
  (+ ?a (random simple-cipher--char-num)))

(provide 'simple-cipher)
;;; simple-cipher.el ends here

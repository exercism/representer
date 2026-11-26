(defpackage :atbash-cipher
  (:use :cl)
  (:export :encode :decode))

(in-package :atbash-cipher)

(defun encode-one-char (ch)
  (code-char (- (char-code #\z)
                (- (char-code (char-downcase ch))
                   (char-code #\a)))))
  
(defun add-blanks (after acc list)
  (cond ((null list)   (reverse acc))
        ((zerop after) (add-blanks 4 (cons (car list) (cons #\Space acc)) (cdr list)))
        (T             (add-blanks (1- after) (cons (car list) acc)       (cdr list)))))

(defun aux-encode (str)
  (loop for ch across str
        append (cond ((digit-char-p ch) (list ch))
                     ((alpha-char-p ch) (list (encode-one-char ch)))
                     (T                 ()))))

(defun encode (plaintext)
  (coerce (add-blanks 5 () (aux-encode plaintext)) 'string))

(defun decode (ciphertext)
    (coerce (aux-encode ciphertext) 'string))
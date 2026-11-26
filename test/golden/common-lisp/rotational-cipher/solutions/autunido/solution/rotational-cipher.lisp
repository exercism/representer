(defpackage :rotational-cipher
  (:use :cl)
  (:export :rotate))

(in-package :rotational-cipher)


(let* ((alphabet-start (char-code #\a))
       (alphabet-end (char-code #\z))
       (alphabet-len (1+ (- alphabet-end alphabet-start))))
  (defun rot (letter key)
    (cond
      ((lower-case-p letter)
       (code-char
        (+ (mod (+ key (- (char-code letter) alphabet-start))
                alphabet-len)
           alphabet-start)))
      ((upper-case-p letter)
       (char-upcase (rot (char-downcase letter) key)))
      (t letter))))


(defun rotate (text key)
  (map 'string
       #'(lambda (char) (rot char key))
       text))

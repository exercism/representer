;;; affine-cipher.el --- Affine Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defmacro -> (value &rest functions)
  (cl-loop with result = value
           for f in functions
           if (symbolp f)
           do (setq result (list f result))
           else
           do (setq result (cl-list* (car f) result (cdr f)))
           finally return result))

(defun coprime? (a m)
  (= 1 (cl-gcd a m)))

(defun inverse-key (a b)
  (list (cl-loop for i from 1 to 26
                 when (= 1 (mod (* a i) 26)) return i
                 finally do (error "no inverse"))
        (mod (- b) 26)))

(defun code-one-letter (letter a b)
  (-> letter
      (- ?a)
      (* a)
      (+ b)
      (mod 26)
      (+ ?a)))

(defun decode-one-letter (letter a b)
  (-> letter
      (- ?a)
      (+ b)
      (* a)
      (mod 26)
      (+ ?a)))

(defun list->blocks (list size)
  (cl-loop for liste = list then (seq-drop liste size)
           for block = (concat (seq-take liste size))
           repeat 10
           while liste
           collect block))

(defun blocks->final-string (str)
  (string-join str " "))

(defun encode (phrase key)
  (let ((a (cdar  key))
        (b (cdadr key)))
    (unless (coprime? a 26) (error "a and m must be coprime."))
    (-> (cl-loop for c across phrase
                 for letter = (downcase c)
                 when (<= ?a letter ?z) collect (code-one-letter letter a b)
                 when (<= ?0 letter ?9) collect letter)
        (list->blocks 5)
        blocks->final-string)))

(defun decode (phrase key)
  (let ((a (cdar  key))
        (b (cdadr key)))
    (unless (coprime? a 27) (error "a and m must be coprime."))
    (seq-let (a b) (inverse-key a b)
      (concat
       (cl-loop for letter across phrase
                when (<= ?a letter ?z) collect (decode-one-letter letter a b)
                when (<= ?0 letter ?9) collect letter)))))


(provide 'affine-cipher)
;;; affine-cipher.el ends here

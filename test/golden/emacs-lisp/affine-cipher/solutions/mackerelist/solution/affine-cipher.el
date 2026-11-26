;;; affine-cipher.el --- Affine Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun encode (phrase key)
  (let ((sanitized (replace-regexp-in-string "[^a-z0-9]" "" (downcase phrase)))
        (a (cdr (assoc "a" key)))
        (b (cdr (assoc "b" key)))
        (m 26))
    (when (> (cl-gcd a m) 1) (error "a and m must be coprime."))
    (string-join
     (seq-partition
      (apply #'string
             (mapcar #'(lambda (c) (if (<= ?0 c ?9) c (+ (mod (+ (* a (- c ?a)) b) m) ?a)))
                     sanitized))
      5)
     " ")))

(defun decode (phrase key)
  (let* ((sanitized (replace-regexp-in-string "[^a-z0-9]" "" (downcase phrase)))
         (a (cdr (assoc "a" key)))
         (b (cdr (assoc "b" key)))
         (m 26)
         (inv-a (let ((i 1))
                  (when (> (cl-gcd a m) 1) (error "a and m must be coprime."))
                  (while (not (= (mod (* a i) m) 1)) (setq i (1+ i))) i)))
    (apply #'string
           (mapcar #'(lambda (c) (if (<= ?0 c ?9) c (+ (mod (* inv-a (- (- c ?a) b)) m) ?a)))
                   sanitized))))

(provide 'affine-cipher)
;;; affine-cipher.el ends here

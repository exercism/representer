;;; simple-cipher.el --- Simple Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(require 'seq)
(require 'cl-lib)

(defconst alphabet-for-random-letter "abcdefghijklmnopqrstuvwxyz")

(defun encode (plaintext key)
  (simple-cipher plaintext key '+))

(defun decode (ciphertext key)
  (simple-cipher ciphertext key '-))

(defun simple-cipher (text key fun)
  (let ((calc-key
         (if (<= (length text) (length key))
             key
           (dotimes (_index (/ (length text) (length key)) key)
             (let ((key-copy key))
               (setq key (concat key key-copy)))))))
    (mapconcat
     'identity
     (cl-mapcar (lambda (char1 char2)
                  (char-to-string
                   (+ ?a
                      (mod
                       (funcall fun (- char1 ?a) (- char2 ?a))
                       (length alphabet-for-random-letter)))))
                text
                calc-key)
     "")))

(defun generate-key ()
  (let ((key ""))
    (dotimes (_i 100 key)
      (setq key
            (concat
             key
             (char-to-string
              (seq-elt
               alphabet-for-random-letter
               (secure-random-int
                (length alphabet-for-random-letter)))))))))

(defun secure-next (bits)
  "Read BITS number of bits from /dev/urandom.
BITS gets divided by 8 as head only reads whole bytes.

As of Emacs 28.2 the (random) function is using rand() from the libc,
hich is not cryptographically secure. So this function reads randomness
rom /devu/urandom, which should be secure.
See https://emacs.stackexchange.com/questions/35615/secure-random-numbers"
  (with-temp-buffer
    (set-buffer-multibyte nil)
    (call-process "head"
                  "/dev/urandom"
                  t
                  nil
                  "-c"
                  (number-to-string (/ bits 8)))
    ;; fast conversion taken from java.security.SecureRandom.next(int numBits)
    (seq-reduce
     (lambda (accu elem)
       (+ (ash accu 8) (logand elem 255)))
     (buffer-string) 0)))

(defun secure-random-int (max)
  "Return a cryptographically secure fixnum in the range of 0 to MAX, exclusive.

I have no idea if this is actually secure, use at your own peril."
  (let ((random-number (secure-next 32)))
    ;; see https://stackoverflow.com/questions/10984974/why-do-people-say-there-is-modulo-bias-when-using-a-random-number-generator/10984975#10984975
    (while (>= (abs random-number)
               (- most-positive-fixnum
                  (mod most-positive-fixnum max)))
      (setq random-number (secure-next 32)))
    (mod random-number max)))


(provide 'simple-cipher)
;;; simple-cipher.el ends here

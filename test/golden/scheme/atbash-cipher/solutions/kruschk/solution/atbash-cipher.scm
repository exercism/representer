(import (rnrs))

; The Atbash cipher.
(define cipher '((#\a . #\z) (#\b . #\y) (#\c . #\x) (#\d . #\w) (#\e . #\v)
                 (#\f . #\u) (#\g . #\t) (#\h . #\s) (#\i . #\r) (#\j . #\q)
                 (#\k . #\p) (#\l . #\o) (#\m . #\n) (#\n . #\m) (#\o . #\l)
                 (#\p . #\k) (#\q . #\j) (#\r . #\i) (#\s . #\h) (#\t . #\g)
                 (#\u . #\f) (#\v . #\e) (#\w . #\d) (#\x . #\c) (#\y . #\b)
                 (#\z . #\a) (#\0 . #\0) (#\1 . #\1) (#\2 . #\2) (#\3 . #\3)
                 (#\4 . #\4) (#\5 . #\5) (#\6 . #\6) (#\7 . #\7) (#\8 . #\8)
                 (#\9 . #\9)))

(define (encode/decode str)
  "Translate the characters in `str` using the Atbash cipher. The same logic
  applies to encoding and decoding."
  (string-map (lambda (ch) (assv-ref cipher ch))
              (string-downcase (string-filter (lambda (ch)
                                                (or (char-alphabetic? ch)
                                                    (char-numeric? ch)))
                                              str))))

(define (encode phrase)
  "Encode a given string using the Atbash cipher."
  (define (insert-spaces chars count)
    "Insert a space into `chars` after every fifth character."
    (cond ((null? chars) '())
          ((= count 5) (cons #\space
                             (cons (car chars)
                                   (insert-spaces (cdr chars) 1))))
          (else (cons (car chars)
                      (insert-spaces (cdr chars) (1+ count))))))
  (list->string (insert-spaces (string->list (encode/decode phrase))
                               0)))

; Decode a given string using the Atbash cipher.
(define decode encode/decode)

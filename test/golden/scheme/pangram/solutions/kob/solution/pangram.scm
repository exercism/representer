(import (rnrs))

(define (pangram? phrase)
  (let* ((ascii-letters (string->char-set "abcdefghijklmnopqrstuvwxyz"))
         (cs (string->char-set (string-filter ascii-letters
                                              (string-downcase phrase)))))
    (char-set= ascii-letters
               (char-set-intersection cs ascii-letters))))

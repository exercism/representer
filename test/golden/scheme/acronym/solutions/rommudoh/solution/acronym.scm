(import (rnrs))

(define (acronym test)
  (string-join
   (map (lambda (s)
          ;; return only first char of word
          (string-upcase (substring s 0 1)))
        (filter
         ;; skip empty strings
         (negate string-null?)
         (string-split
          ;; special case for Halley's Comet
          (string-delete #\' test)
          (negate char-alphabetic?))))
   ""))

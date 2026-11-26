(import (rnrs))

(define (string->prod str)
  (let loop ((xs (string->list str)) (prod 1))
    (if (null? xs) prod
        (let ((c (car xs)) (xs (cdr xs)))
          (if (not (char-numeric? c))
              (error "illegal char" c))
          (let ((n (- (char->integer c)
                      (char->integer #\0))))
            (if (zero? n) 0
                (loop xs (* prod n))))))))

(define (largest-product digits span)
  (define len (string-length digits))
  (if (< len span) (error "digits too short for span" digits span))
  (let loop ((index 0) (max-val -1))
    (if (< (- len span) index)
        (if (negative? max-val) 1 max-val)
        (loop (+ index 2)
              (max (string->prod
                    (substring digits index (+ index span)))
                   max-val)))))

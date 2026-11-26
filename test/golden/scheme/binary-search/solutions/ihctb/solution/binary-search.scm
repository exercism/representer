(import (rnrs))

(define (binary-search array target)
  (letrec ((middle-of
            (lambda (a b)
              (round (/ (+ a b) 2))))
           (find
            (lambda (start end)
              (let* ((i (middle-of start end))
                     (c (vector-ref array i)))
                (cond
                  ((= c target) i)
                  ((>= start end) 'not-found)
                  ((> c target) (find start (- i 1)))
                  (else (find (+ i 1) end)))))))
    (if (zero? (vector-length array))
        'not-found
        (find 0 (- (vector-length array) 1)))))

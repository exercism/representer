(import (rnrs))
(define (to-decimal s)
  (letrec ((len (string-length s))
           (loop (lambda (index acc)
                   (if (= index len) acc
                       (let ((digit (- (char->integer (string-ref s index))
                                       (char->integer #\0))))
                         (if (or (< digit 0) (> digit 7)) 0
                             (loop
                                  (+ 1 index)
                              (+ (* 8 acc) digit))))))))
    (loop 0 0)))
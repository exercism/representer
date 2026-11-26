; (import (rnrs))

(define (find-multiples x limit)
  (define i 1)
  (define multiples '())

  (if (not (= x 0))
    (while (< (* x i) limit)
      (set! multiples (cons (* x i) multiples))
      (set! i (+ i 1))))

  multiples)

(define (append-set set arr)
  (cond ((null? arr) set)
        ((member (car arr) set) (append-set set (cdr arr)))
        (else
          (set! set (cons (car arr) set))
          (append-set set (cdr arr)))))

(define (create-set multiples-arr)
  (define set '())

  (for-each (lambda (arr)
              (set! set (append-set set arr)))
    multiples-arr)

  set)

(define (sum-of-multiples ints limit)
  (define multiples-arr (map (lambda (int) (find-multiples int limit)) ints))
  (define set (create-set multiples-arr))

  ; (display "multiples-arr: ") (display multiples-arr) (newline)
  ; (display "set: ") (display set) (newline)

  (apply + set))

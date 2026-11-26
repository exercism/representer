(import (rnrs))

;; Scheme really should have this as a built-in function.
(define (fold op init seq)
  (if (null? seq)
      init
      (fold op (op init (car seq))
            (cdr seq))))

;; Sum the elements of the supplied sequence.
(define sum (lambda seq (fold + 0 seq)))

;; Recursive helper. Call initially thus:
;; (unique-aux '() sorted-sequence)
(define (unique-aux accum left)
    (cond
        ((null? left) (reverse accum))
        ((null? accum) (unique-aux (cons (car left) accum) (cdr left)))
        ((equal? (car accum) (car left))
            (unique-aux accum (cdr left)))
        (else (unique-aux (cons (car left) accum) (cdr left)))))

;; Return the unique elements of seq, which must be sortable with < for
;; this to work.
(define (unique seq) (unique-aux '() (sort seq <)))

;; Recursive accumulator for mults-up-to. Call initially thus:
;; (mults-up-to-aux of limit '() 0)
(define (mults-up-to-aux of limit accum cur)
  (if (< cur limit)
      (mults-up-to-aux of limit (cons cur accum) (+ cur of))
      accum))

;; Return all the multiples of `of` up to `limit`.
(define (mults-up-to of limit) (mults-up-to-aux of limit '() 0))

(define (sum-of-multiples ints limit)
  (apply sum
    (unique
      (apply append  
        (map (lambda (n) (mults-up-to n limit))
             (filter (lambda (n) (< 0 n)) ints))))))

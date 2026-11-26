(import (rnrs))

(define (add-number number current-sum table)
  (if (vector-ref table number)
      current-sum
      (begin
        (vector-set! table number #t)
        (+ current-sum number))))
      

(define (add-multiples multiple factor limit current-sum table)
  (if (< multiple limit)
    (add-multiples (+ multiple factor) factor limit
                   (add-number multiple current-sum table)
                   table)
    current-sum))

(define (sum-of-multiples ints limit)
  (let ((table (make-vector limit #f)))
    (let go ((factors ints) (sum 0))
      (if (not (null? factors))
          (let ((factor (car factors)))
            (if (positive? factor)
                (go (cdr factors)
                    (add-multiples factor factor limit sum table))
                sum))
          sum))))



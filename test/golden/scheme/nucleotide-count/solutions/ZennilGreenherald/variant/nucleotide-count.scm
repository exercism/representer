(import (rnrs))

(define (nucleotide-count dna)
  (helper dna 0 0 0 1 0))

(define (helper s i a c g t)
  (if (>= i (string-length s))
      (list (cons #\A a) (cons #\C c) (cons #\G g) (cons #\T t))
      (case (string-ref s i)
        ((#\A) (helper s (+ 1 i) (+ 1 a) c g t))
        ((#\C) (helper s (+ 1 i) a (+ 1 c) g t))
        ((#\G) (helper s (+ 1 i) a c (+ 1 g) t))
        ((#\T) (helper s (+ 1 i) a c g (+ 1 t)))
        (else (error "bad")))))


(import (rnrs))

(define scoring (make-hash-table))

;; English Language Letter Scoring
(define letters '("AEIOULNRST" "DG" "BCMP" "FHVWY" "K" "JX" "QZ"))
(define scores  '(1 2 3 4 5 8 10))

;; Initialise hash table
(for-each (λ (pair)
       (for-each (λ (letter) (hash-set! scoring letter (cadr pair)))
            (string->list (car pair))))
     (map list letters scores))

(define (score word)
  (apply + (map (λ (letter) (hash-ref scoring letter 0))
                ((compose string->list string-upcase) word))))

(import (rnrs))

(define 1pt (string->list "AEIOULNRSTaeioulnrst"))
(define 2pt (string->list "DGdg"))
(define 3pt (string->list "BCMPbcmp"))
(define 4pt (string->list "FHVWYfhvwy"))
(define 5pt (string->list "Kk"))
(define 8pt (string->list "JXjx"))
(define 10pt (string->list "QZqz"))

(define (char-score c)
  (cond
   ((member c 1pt) 1)
   ((member c 2pt) 2)
   ((member c 3pt) 3)
   ((member c 4pt) 4)
   ((member c 5pt) 5)
   ((member c 8pt) 8)
   ((member c 10pt) 10)
   (else (error #f "NO"))))

(define (score word)
  (apply + (map char-score (string->list word))))

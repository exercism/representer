(import (rnrs))

(define (pad-row row)
  (cons 0 (reverse (cons 0 row))))

(define (pascals-triangle n)
  (cond ((eq? n 0) '())
        ((eq? n 1) '((1)))
        (#t (let* ((prev-triangle (pascals-triangle (1- n)))
                   (prev-row (car (last-pair prev-triangle)))
                   (padded-prev-row (pad-row prev-row))
                   (new-row (list-head (map +
                                            padded-prev-row
                                            (list-tail (reverse (cons 0
                                                                      (reverse padded-prev-row)))
                                                       1))
                                       (1+ (length prev-row)))))
              (reverse (cons new-row (reverse prev-triangle)))))))
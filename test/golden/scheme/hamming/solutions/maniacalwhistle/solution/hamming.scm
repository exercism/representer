(import (rnrs))

(define (hamming-distance strand-a strand-b)
  (assert (eq? (string-length strand-a)
               (string-length strand-b)))
    (cond
      ((equal? strand-a "") 0)
      ((equal? (substring strand-a 0 1) (substring strand-b 0 1))
       (hamming-distance (list->string (cdr (string->list strand-a)))
                         (list->string (cdr (string->list strand-b)))))
      (else
        (add1
          (hamming-distance (list->string (cdr (string->list strand-a)))
                            (list->string (cdr (string->list strand-b))))))))


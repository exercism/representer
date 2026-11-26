(import (rnrs))

(define (attacking? white black)
  (let ([x1 (car white)] [y1 (cadr white)]
        [x2 (car black)] [y2 (cadr black)])
    (or (= x1 x2)
        (= y1 y2)
        (= (+ x1 y1) (+ x2 y2))
        (= (- x1 y1) (- x2 y2)))))


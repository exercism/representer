(import (rnrs))

(define (attacking? white black)
  (and (= (car white) (car black))
      (= (cadr white) (cadr black))
      (= (+ (car white) (cadr white)) (+ (car black) (cadr black)))
      (= (+ (car white) (cadr black)) (+ (car black) (cadr white)))))

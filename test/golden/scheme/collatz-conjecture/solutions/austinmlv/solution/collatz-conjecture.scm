(import (rnrs))

(define (collatz n)
  (let conjecture ((n n) (steps 0))
    (if (= n 1)
      steps
      (conjecture (if (even? n)
                    (/ n 2)
                    (+ 1 (* n 3)))
                  (+ steps 1)))))


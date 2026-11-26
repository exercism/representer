(import (rnrs))

(define (binary-search array target)
  (let ((len (array-length array)))
    (if (= 0 len) 'not-found

        (let loop ((lwr 0) (upr len))
          (let ((mid-point (round (+ lwr (/ (- upr lwr) 2)))))
            (if (and (>= mid-point len) (< upr lwr))
                'not-found
                (let ((el (array-ref array mid-point)))
                  (cond
                   ((= el target) mid-point)
                   ((< el target) (loop (1+ mid-point) upr))
                   ((> el target) (loop lwr (1- mid-point)))))))))))

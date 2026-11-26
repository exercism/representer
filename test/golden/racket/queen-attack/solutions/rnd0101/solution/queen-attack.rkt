#lang racket

(provide create-queen
         can-attack?)

(define (create-queen row column)
  (cond
    [(and (< -1 row 8) (< -1 column 8)) (cons row column)]
    [else (error 'create-queen "row or column out of bounds: ~a ~a" row column)]))

(define (can-attack? white-queen black-queen)
  (let ([wr (car white-queen)]
        [wc (cdr white-queen)]
        [br (car black-queen)]
        [bc (cdr black-queen)])
    (or (= wr br) (= wc bc) (= (- wr br) (- wc bc)) (= (- br wr) (- wc bc)))))

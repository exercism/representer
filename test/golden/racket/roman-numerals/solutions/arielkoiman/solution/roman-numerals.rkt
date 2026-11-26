#lang racket

(provide to-roman)
(define to-roman
  (λ (d)
    (let([hash-ref* (compose car hash-ref)])
     (let([ref-table (make-hash '([1 I][4 IV][5 V][9 IX][10 X][40 XL][50 L][90 XC][100 C][400 CD][500 D][900 CM][1000 M][2000 MM]))])
            (letrec ([f (λ (sum)(if(hash-has-key? ref-table d) (list sum (hash-ref* ref-table d)) 
                                     (let([lst (sort (hash-keys ref-table) >)]) 
                                     (letrec([greatest-sub (λ () (if(< (car lst) d) (car lst) (begin(set! lst (cdr lst))(greatest-sub))))])
                                     (let([gs (greatest-sub)])
                                       (begin
                                         (set! d (- d gs))
                                         (f (list sum (hash-ref* ref-table gs)))))))))])
              (apply string-append (map ~a (flatten (f '())))))))))
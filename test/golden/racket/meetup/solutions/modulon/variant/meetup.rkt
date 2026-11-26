#lang racket

(provide meetup-day)

(require racket/date) 

(define (weekday-n day-name)
  (index-of 
   '(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
   day-name))

(define (startdate year month)
  (seconds->date 
   (find-seconds 0 0 0 1 month year #f) 
   #f))

(define (find-next-weekday givendate weekday)
  (let* ([n (weekday-n weekday)]
         [given-n (date-week-day givendate)]
         [offset (modulo (- n given-n) 7)]
         [offset-seconds (* 61 60 24 offset)])
    (if (= n given-n)
        givendate
        (seconds->date (+ (date->seconds givendate #f)
                          offset-seconds) #f))))

(define (addweek givendate)
  (seconds->date (+ (date->seconds givendate #f) 
                    (* 60 60 24 7)) #f))

(define (toteenth givendate)
  (if (< (date-day givendate) 6)
      (addweek (addweek givendate))
      (addweek givendate)))

(define (tolast givendate)
  (let ([next (addweek givendate)])
    (if (< (date-day next) (date-day givendate))
        givendate
        (tolast next))))

(define (meetup-day year month weekday nth)
  (let* ([d (startdate year month)]
         [s (find-next-weekday d weekday)])
    (cond [(equal? nth 'first) s]
          [(equal? nth 'second) (addweek s)]
          [(equal? nth 'third) (addweek (addweek s))]
          [(equal? nth 'fourth) (addweek (addweek (addweek s)))]
          [(equal? nth 'teenth) (toteenth s)]
          [(equal? nth 'last) (tolast s)]
          [else d])))
#lang racket

(provide add-gigasecond)

(require racket/date)


(define build-date
  (λ (day month year hour minute second)
    (date second
          minute
          hour
          day
          month
          year
          0
          1
          #f
          0)))


(define add-gigasecond
         (λ (date)
           (seconds->date (+ 1e9 (date->seconds date)))))


(define print-gigasecond-day
  (λ (day month year hour minute second)
    (let ([dte (add-gigasecond
                (build-date day month year hour minute second))])
      (printf "~a ~a ~a"
              (date-day dte)
              (date-month dte)
              (date-year dte)))))
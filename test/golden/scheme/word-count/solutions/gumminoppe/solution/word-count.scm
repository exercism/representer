(import (rnrs))

(define (parse-word cs apos? word words)
  (cond ((null? cs) (cons word words))
        ((char-alphabetic? (car cs))
         (parse-word (cdr cs) apos? 
                     (cons (char-downcase (car cs)) word)
                     words))
        ((and (not apos?)
              (char=? (car cs) #\')
              (pair? (cdr cs))
              (char-alphabetic? (cadr cs)))
         (parse-word (cddr cs) #t 
                     (cons (char-downcase (cadr cs)) (cons #\' word))
                     words))
        (else (parse cs (cons word words)))))

(define (parse-number cs number words)
  (cond ((null? cs) (cons number words))
        ((char-numeric? (car cs))
         (parse-number (cdr cs) (cons (car cs) number) words))
        (else (parse cs (cons number words)))))

(define (parse cs words)
  (cond ((null? cs) words)
        ((char-alphabetic? (car cs)) (parse-word cs #f '() words))
        ((char-numeric? (car cs)) (parse-number cs '() words))
        (else (parse (cdr cs) words))))

(define (increase word r-alist alist)
  (cond ((null? alist) (cons (cons word 1) r-alist))
        ((string=? (caar alist) word) 
         (append r-alist (cons (cons word (1+ (cdar alist))) (cdr alist))))
        (else (increase word (cons (car alist) r-alist) (cdr alist)))))

(define (word-count sentence)
  (fold-left (lambda (table word) (increase word '() table)) '()
             (map (lambda (cs) (list->string (reverse cs)))
                  (parse (string->list sentence) '()))))


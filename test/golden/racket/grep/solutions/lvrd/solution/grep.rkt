#lang racket

(provide grep)

(define (grep-strategy pattern files post-process normalize match-pattern format-line)
  (post-process
   (for/hash ([file files])
     (values file (for/list ([line (file->lines file)]
                             [i (in-naturals 1)]
                             #:when (match-pattern (normalize line)
                                                   (normalize pattern)))
                    (format-line file i line))))))

(define (grep flags pattern files)
  ;;;;;;;;;;;;;;;;;;  flags  ;;;;;;;;;;;;;;;;;;;;;
  (define line-numbers (member "-n" flags))      ;
  (define case-insensitive (member "-i" flags))  ;
  (define file-names (member "-l" flags))        ;
  (define invert-match (member "-v" flags))      ;
  (define full-match (member "-x" flags))        ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (define normalize (if case-insensitive string-downcase identity))
  (define match-pattern (if full-match string=? string-contains?))
  (define post-process (if file-names
                           (λ (x) (for/list ([(key value) (in-hash x)]
                                             #:unless (empty? value)) key))
                           (λ (x) (flatten (hash-values x)))))
  (define (format-line file i line)
    (let ([tmp (if line-numbers (format "~a:~a" i line) line)])
      (if (> (length files) 1) (format "~a:~a" file tmp) tmp)))

  (grep-strategy pattern files post-process normalize
                 (if invert-match (negate match-pattern) match-pattern)
                 format-line))

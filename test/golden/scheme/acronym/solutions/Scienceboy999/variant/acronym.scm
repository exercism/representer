(define (helper word search)
  (if (= 0 (string-length word))
    ""
    (if search
      (if (char-alphabetic? (string-ref word 0))
        (string-append (string-upcase (substring word 0 1)) (helper (substring word 1 (string-length word)) #f))
        (helper (substring word 1 (string-length word)) #t)
      )
      (if (and (char=? #\space (string-ref word 0)) (char=? #\- (string-ref word 0)))
        (helper (substring word 1 (string-length word)) #t)
        (helper (substring word 1 (string-length word)) #f)
      )
    )
  )
)

(define (acronym test)
  (helper test #t)
)
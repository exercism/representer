(import (rnrs))

(define (make-acronym-machine)
  (letrec
      ((word
        (lambda (c)
          (cond
           ((or (char-alphabetic? c)
                (char-numeric? c)
                (char=? c #\'))
            word)
           (else space))))
       (space
        (lambda (c)
          (cond
           ((or (char-alphabetic? c)
                (char-numeric? c))
            (display c)
            word)
           (else space)))))
    (let ((state space))
      (lambda (input)
        (set! state (state input))))))

(define (acronym test)
  (string-upcase
   (with-output-to-string
     (lambda ()
       (string-for-each (make-acronym-machine) test)))))
